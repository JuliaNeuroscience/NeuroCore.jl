module ColorChannels

using AxisIndices
using AxisIndices.Interface: NamedDimsArray
using Reexport
using FFTW

@reexport using FixedPointNumbers
@reexport using Colors

if isdefined(ColorTypes, :XRGB) && isdefined(ColorTypes, :RGB1)
    Base.@deprecate_binding RGB1 XRGB
    Base.@deprecate_binding RGB4 RGBX
end
# backward compatibility for ColorTypes < v0.9
if !isdefined(ColorTypes, :XRGB)
    const XRGB = RGB1
    const RGBX = RGB4
end

using MappedArrays
using MappedArrays: AbstractMultiMappedArray, AbstractMappedArray

using AxisIndices.PaddedViews
using .ColorTypes: colorant_string
using Colors: Fractional

using Base: tail, @pure, Indices
import Base: float

# TODO: just use .+
# See https://github.com/JuliaLang/julia/pull/22932#issuecomment-330711997
plus(r::AbstractUnitRange, i::Integer) = broadcast(+, r, i)
plus(a::AbstractArray, i::Integer) = a .+ i

using .ColorTypes: AbstractGray, TransparentGray, Color3, Transparent3
Color1{T} = Colorant{T,1}
Color2{T} = Colorant{T,2}
Color4{T} = Colorant{T,4}
AColor{N,C,T} = AlphaColor{C,T,N}
ColorA{N,C,T} = ColorAlpha{C,T,N}
const NonparametricColors = Union{RGB24,ARGB32,Gray24,AGray32}
Color1Array{C<:Color1,N} = AbstractArray{C,N}
# Type that arises from reshape(reinterpret(To, A), sz):
const RRArray{To,From,N,M,P} = Base.ReshapedArray{To,N,Base.ReinterpretArray{To,M,From,P}}
const RGArray = Union{Base.ReinterpretArray{<:AbstractGray,M,<:Number,P}, Base.ReinterpretArray{<:Number,M,<:AbstractGray,P}} where {M,P}

# delibrately not export these constants to enable extensibility for downstream packages
const NumberLike = Union{Number,AbstractGray}
const Pixel = Union{Number,Colorant}
const GenericGrayImage{T<:NumberLike,N} = AbstractArray{T,N}
const GenericImage{T<:Pixel,N} = AbstractArray{T,N}

export
    StackedView,
    channel_view,
    color_view,
    permuteddimsview,
    raw_view,
    normed_view,
    reinterpretc,
    # conversions
#    float16,
    float32,
    float64,
    n0f8,
    n6f10,
    n4f12,
    n2f14,
    n0f16,
    # mapping values
    clamp01,
    clamp01!,
    clamp01nan,
    clamp01nan!,
    colorsigned,
    scaleminmax,
    scalesigned,
    takemap,
    # spatial
    # channels
    channeldim,
    channel_axis,
    channel_axis_type,
    channel_keys,
    channel_indices,
    nchannel,
    select_channeldim,
    zeroarray

include("channels.jl")
include("stackedviews.jl")
include("convert_reinterpret.jl")
include("map.jl")
include("functions.jl")

is_channel(x::Symbol) = x === :channel || x === :Channel || x === :Color || x === :color
AxisIndices.@defdim channel is_channel

"""
    raw_view(img::AbstractArray{FixedPoint})

returns a "view" of `img` where the values are interpreted in terms of
their raw underlying storage. For example, if `img` is an `Array{N0f8}`,
the view will act like an `Array{UInt8}`.

See also: [`normed_view`](@ref)
"""
raw_view(a::AbstractArray{T}) where {T<:FixedPoint} = mappedarray(reinterpret, y->T(y,0), a)
raw_view(a::Array{T}) where {T<:FixedPoint} = reinterpret(FixedPointNumbers.rawtype(T), a)
raw_view(a::AbstractArray{T}) where {T<:Real} = a

"""
    normed_view([T], img::AbstractArray{Unsigned})

returns a "view" of `img` where the values are interpreted in terms of
`Normed` number types. For example, if `img` is an `Array{UInt8}`, the
view will act like an `Array{N0f8}`.  Supply `T` if the element
type of `img` is `UInt16`, to specify whether you want a `N6f10`,
`N4f12`, `N2f14`, or `N0f16` result.

See also: [`raw_view`](@ref)
"""
normed_view(::Type{T}, a::AbstractArray{S}) where {T<:FixedPoint,S<:Unsigned} = mappedarray(y->T(y,0),reinterpret, a)
normed_view(::Type{T}, a::Array{S}) where {T<:FixedPoint,S<:Unsigned} = reinterpret(T, a)
normed_view(::Type{T}, a::AbstractArray{T}) where {T<:Normed} = a
normed_view(a::AbstractArray{UInt8}) = normed_view(N0f8, a)
normed_view(a::AbstractArray{T}) where {T<:Normed} = a

# PaddedViews support
# This make sure Colorants as `fillvalue` are correctly filled, for example, let
# `PaddedView(ARGB(0, 0, 0, 0), img)` correctly filled with transparent color even when
# `img` is of eltype `RGB`
function PaddedViews.filltype(::Type{FC}, ::Type{C}) where {FC<:Colorant, C<:Colorant}
    # rand(RGB, 4, 4) has eltype RGB{Any} but it isn't a concrete type
    # although the consensus[1] is to not make a concrete eltype, this op is needed to make a
    # type-stable colorant construction in _filltype without error; there's no RGB{Any} thing
    # [1]: https://github.com/JuliaLang/julia/pull/34948
    T = eltype(C) === Any ? eltype(FC) : eltype(C)
    return _filltype(FC, base_colorant_type(C){T})
end
_filltype(::Type{<:Colorant}, ::Type{C}) where {C<:Colorant} = C
_filltype(::Type{FC}, ::Type{C}) where {FC<:Color3, C<:AbstractGray} =
    base_colorant_type(FC){promote_type(eltype(FC), eltype(C))}
_filltype(::Type{FC}, ::Type{C}) where {FC<:TransparentColor, C<:AbstractGray} =
    alphacolor(FC){promote_type(eltype(FC), eltype(C))}
_filltype(::Type{FC}, ::Type{C}) where {FC<:TransparentColor, C<:Color3} =
    alphacolor(C){promote_type(eltype(FC), eltype(C))}

# Support transpose
Base.transpose(a::AbstractMatrix{C}) where {C<:Colorant} = permutedims(a, (2,1))
function Base.transpose(a::AbstractVector{C}) where C<:Colorant
    ind = axes(a, 1)
    out = similar(Array{C}, (oftype(ind, Base.OneTo(1)), ind))
    outr = reshape(out, ind)
    copy!(outr, a)
    out
end

end
