# Create a special type for permutations. The real point here is to be able to
# unambiguously identify an RRPermArray (see below) so that we may "unwrap" in
# expressions like `channel_view(color_view(C, A))`.

"""
ColorChanPerm(perm)

Construct a reordering permutation for the color channel.
This handles swaps between memory layout and constructor argument order for `AbstractRGB` and
various `AlphaChannel` and `ChannelAlpha` color types.
"""
struct ColorChanPerm{N} <: AbstractVector{Int}
    perm::NTuple{N,Int}
end
Base.IndexStyle(::Type{<:ColorChanPerm}) = IndexLinear()
Base.size(v::ColorChanPerm{N}) where N = (N,)
Base.getindex(v::ColorChanPerm, i::Int) = v.perm[i]

dimorder(::Type{<:RGB}) = ColorChanPerm((1, 2, 3))
dimorder(::Type{<:BGR}) = ColorChanPerm((3, 2, 1))
dimorder(::Type{<:XRGB}) = ColorChanPerm((1, 1, 2, 3))
dimorder(::Type{<:RGBX}) = ColorChanPerm((1, 2, 3, 3)) # this causes problems for setindex!, fixed below
dimorder(::Type{<:BGRA}) = ColorChanPerm((3, 2, 1, 4))
dimorder(::Type{<:ABGR}) = ColorChanPerm((4, 3, 2, 1))
dimorder(::Type{<:AlphaColor{<:Color1,T,N}}) where {T,N} = ColorChanPerm((2, 1))
dimorder(::Type{<:AlphaColor{<:Color3,T,N}}) where {T,N} = ColorChanPerm((4, 1, 2, 3))

const ColorChanPermIndexType{NC} = Tuple{<:ColorChanPerm,Vararg{<:Base.Slice,NC}}
const ColorChanPermSubArray{T,N,P,I<:ColorChanPermIndexType,L} =
    SubArray{T,N,P,I,L}
const RRPermArray{To,From,N,M,P<:ColorChanPermSubArray} =
    RRArray{To,From,N,M,P}

# This type exists solely to set multiple values in the color channel axis
struct NVector{T,N} <: AbstractVector{T}
    v::NTuple{N,T}
end
Base.IndexStyle(::Type{<:NVector}) = IndexLinear()
Base.size(v::NVector{T,N}) where {T,N} = (N,)
Base.getindex(v::NVector, i::Int) = v.v[i]
NVector(x::Vararg{T,N}) where {T,N} = NVector{T,N}(x)

@inline Base.setindex!(A::RRPermArray{<:RGBX,<:Number,N}, val::AbstractRGB, i::Vararg{Int,N}) where N =
    setindex!(parent(parent(parent(A))), NVector(red(val), green(val), blue(val)), :, i...)

"""
    channel_view(A)

returns a view of `A`, splitting out (if necessary) the color channels
of `A` into a new first dimension.

Of relevance for types like RGB and BGR, the channels of the returned
array will be in constructor-argument order, not memory order (see
`reinterpretc` if you want to use memory order).

# Example
```julia
img = rand(RGB{N0f8}, 10, 10)
A = channel_view(img)   # a 3×10×10 array

See also: [`color_view`](@ref)
"""
channel_view(A::AbstractArray{T}) where {T<:Number} = A
channel_view(A::RRPermArray{<:Colorant,<:Number}) = parent(parent(parent(A)))
channel_view(A::RRArray{<:Colorant,<:Number}) = parent(parent(A))
channel_view(A::Base.ReinterpretArray{<:AbstractGray,M,<:Number}) where M = parent(A)
channel_view(A::AbstractArray{RGB{T}}) where {T} = reinterpretc(T, A)
function channel_view(A::AbstractArray{C}) where {C<:AbstractRGB}
    # BGR, XRGB, etc don't satisfy conditions for reinterpret
    CRGB = RGB{eltype(C)}
    channel_view(of_eltype(CRGB, A))
end
channel_view(A::AbstractArray{C}) where {C<:Color} = reinterpretc(eltype(C), A)
channel_view(A::AbstractArray{C}) where {C<:ColorAlpha} = _channel_view(color_type(C), A)
_channel_view(::Type{<:RGB}, A) = reinterpretc(eltype(eltype(A)), A)
function _channel_view(::Type{C}, A) where {C<:AbstractRGB}
    CRGBA = RGBA{eltype(C)}
    channel_view(of_eltype(CRGBA, A))
end
_channel_view(::Type{C}, A) where {C<:Color} = reinterpretc(eltype(C), A)
function channel_view(A::AbstractArray{AC}) where {AC<:AlphaColor}
    CA = coloralpha(base_color_type(AC)){eltype(AC)}
    channel_view(of_eltype(CA, A))
end
function channel_view(A::NamedDimsArray{L,T,N}) where {L,T,N}
    Ac = channel_view(parent(A))
    if ndims(Ac) === N
        return NamedDimsArray{L}(Ac)
    else
        return NamedDimsArray{(:color, L...)}(Ac)
    end
end
function channel_view(A::AbstractAxisArray{T,N}) where {T,N}
    Ac = channel_view(parent(A))
    if ndims(Ac) === N
        return AxisIndices.unsafe_reconstruct(A, Ac, axes(A))
    else
        return AxisIndices.unsafe_reconstruct(A, Ac, (SimpleAxis(axes(Ac, 1)), axes(A)...))
    end
end



"""
    color_view(C, A)

returns a view of the numeric array `A`, interpreting successive
elements of `A` as if they were channels of Colorant `C`.

Of relevance for types like RGB and BGR, the elements of `A` are
interpreted in constructor-argument order, not memory order (see
`reinterpretc` if you want to use memory order).

# Example
```jl
A = rand(3, 10, 10)
img = color_view(RGB, A)
```

See also: [`channel_view`](@ref)
"""
color_view(::Type{C}, A::AbstractArray{T}) where {C<:Colorant,T<:Number} =
    _ccolor_view(ccolor_number(C, T), A)
_ccolor_view(::Type{C}, A::RRPermArray{T,C}) where {C<:Colorant,T<:Number} =
    parent(parent(parent(A)))
_ccolor_view(::Type{C}, A::RRArray{T,C}) where {C<:Colorant,T<:Number} =
    parent(parent(A))
_ccolor_view(::Type{C}, A::Base.ReinterpretArray{T,M,C}) where {C<:AbstractGray,T<:Number,M} =
    parent(A)
_ccolor_view(::Type{C}, A::Base.ReinterpretArray{T,M,C}) where {C<:RGB,T<:Number,M} =
    reshape(parent(A), Base.tail(axes(parent(A))))
_ccolor_view(::Type{C}, A::Base.ReinterpretArray{T,M,C}) where {C<:AbstractRGB,T<:Number,M} =
    _color_view_reorder(C, A)
_ccolor_view(::Type{C}, A::Base.ReinterpretArray{T,M,C}) where {C<:Color,T<:Number,M} =
    reshape(parent(A), Base.tail(axes(parent(A))))
_ccolor_view(::Type{C}, A::AbstractArray{T}) where {C<:Colorant,T<:Number} =
    __ccolor_view(C, A)  # necessary to avoid ambiguities from dispatch on eltype
__ccolor_view(::Type{C}, A::AbstractArray{T}) where {T<:Number,C<:RGB{T}} = reinterpretc(C, A)
__ccolor_view(::Type{C}, A::AbstractArray{T}) where {T<:Number,C<:AbstractRGB} =
    _color_view_reorder(C, A)
__ccolor_view(::Type{C}, A::AbstractArray{T}) where {T<:Number,C<:Color{T}} = reinterpretc(C, A)
__ccolor_view(::Type{C}, A::AbstractArray{T}) where {T<:Number,C<:ColorAlpha} =
    _color_viewalpha(base_color_type(C), C, eltype(C), A)
__ccolor_view(::Type{C}, A::AbstractArray{T}) where {T<:Number,C<:AlphaColor} =
    _color_view_reorder(C, A)
_color_viewalpha(::Type{C}, ::Type{CA}, ::Type{T}, A::AbstractArray{T}) where {C<:RGB,CA,T} =
    reinterpretc(CA, A)
_color_viewalpha(::Type{C}, ::Type{CA}, ::Type{T}, A::AbstractArray{T}) where {C<:AbstractRGB,CA,T} =
    _color_view_reorder(CA, A)
_color_viewalpha(::Type{C}, ::Type{CA}, ::Type{T}, A::AbstractArray{T}) where {C<:Color,CA,T} =
    reinterpretc(CA, A)

_color_view_reorder(::Type{C}, A) where C = reinterpretc(C, view(A, dimorder(C), Base.tail(colons(A))...))

color_view(::Type{ARGB32}, A::AbstractArray{BGRA{N0f8}}) = reinterpret(ARGB32, A)

color_view(::Type{C1}, A::AbstractArray{C2}) where {C1<:Colorant,C2<:Colorant} =
    color_view(C1, channel_view(A))

colons(A::AbstractArray{T,N}) where {T,N} = ntuple(d->Colon(), Val(N))

"""
    color_view(C, gray1, gray2, ...) -> imgC

Combine numeric/grayscale images `gray1`, `gray2`, etc., into the
separate color channels of an array `imgC` with element type
`C<:Colorant`.

As a convenience, the constant `zeroarray` fills in an array of
matched size with all zeros.

# Example
```julia
imgC = color_view(RGB, r, zeroarray, b)
```

creates an image with `r` in the red chanel, `b` in the blue channel,
and nothing in the green channel.

See also: [`StackedView`](@ref).
"""
function color_view(::Type{C}, gray1, gray2, grays...) where C<:Colorant
    T = _color_view_type(eltype(C), promote_eleltype_all(gray1, gray2, grays...))
    CT = base_colorant_type(C){T}
    axs = firstinds(gray1, gray2, grays...)
    mappedarray(CT, extractchannels, take_zeros(eltype(CT), axs, gray1, gray2, grays...)...)
end

_color_view_type(::Type{Any}, ::Type{T}) where {T} = T
_color_view_type(::Type{T1}, ::Type{T2}) where {T1,T2} = T1

Base.@pure promote_eleltype_all(gray, grays...) = _promote_eleltype_all(beltype(eltype(gray)), grays...)
@inline function _promote_eleltype_all(::Type{T}, gray, grays...) where T
    _promote_eleltype_all(promote_type(T, beltype(eltype(gray))), grays...)
end
_promote_eleltype_all(::Type{T}) where {T} = T

beltype(::Type{T}) where {T} = eltype(T)
beltype(::Type{Union{}}) = Union{}

extractchannels(c::AbstractGray)    = (gray(c),)
extractchannels(c::TransparentGray) = (gray(c), alpha(c))
extractchannels(c::Color3)          = (comp1(c), comp2(c), comp3(c))
extractchannels(c::Transparent3)    = (comp1(c), comp2(c), comp3(c), alpha(c))

## Tuple & indexing utilities

_size(A::AbstractArray) = map(length, axes(A))

# color->number
@inline channel_view_size(parent::AbstractArray{C}) where {C<:Colorant} = (length(C), _size(parent)...)
@inline channel_view_axes(parent::AbstractArray{C}) where {C<:Colorant} =
    _cvi(Base.OneTo(length(C)), axes(parent))
_cvi(rc, ::Tuple{}) = (rc,)
_cvi(rc, inds::Tuple{R,Vararg{R}}) where {R<:AbstractUnitRange} = (convert(R, rc), inds...)
@inline channel_view_size(parent::AbstractArray{C}) where {C<:Color1} = _size(parent)
@inline channel_view_axes(parent::AbstractArray{C}) where {C<:Color1} = axes(parent)

function check_ncolorchan(::AbstractArray{C}, dims) where C<:Colorant
    dims[1] == length(C) || throw(DimensionMismatch("new array has $(dims[1]) color channels, must have $(length(C))"))
end
chanparentsize(::AbstractArray{C}, dims) where {C<:Colorant} = tail(dims)
@inline colparentsize(::Type{C}, dims) where {C<:Colorant} = (length(C), dims...)

channel_view_dims_offset(parent::AbstractArray{C}) where {C<:Colorant} = 1

check_ncolorchan(::AbstractArray{C}, dims) where {C<:Color1} = nothing
chanparentsize(::AbstractArray{C}, dims) where {C<:Color1} = dims
colparentsize(::Type{C}, dims) where {C<:Color1} = dims
channel_view_dims_offset(parent::AbstractArray{C}) where {C<:Color1} = 0

@inline indexsplit(A::AbstractArray{C}, I) where {C<:Colorant} = I[1], tail(I)
@inline indexsplit(A::AbstractArray{C}, I) where {C<:Color1} = 1, I

# number->color
@inline color_view_size(::Type{C}, parent::AbstractArray) where {C<:Colorant} = tail(_size(parent))
@inline color_view_axes(::Type{C}, parent::AbstractArray) where {C<:Colorant} = tail(axes(parent))
@inline color_view_size(::Type{C}, parent::AbstractArray) where {C<:Color1} = _size(parent)
@inline color_view_axes(::Type{C}, parent::AbstractArray) where {C<:Color1} = axes(parent)

function checkdim1(::Type{C}, inds) where C<:Colorant
    inds[1] == (1:length(C)) || throw(DimensionMismatch("dimension 1 must have indices 1:$(length(C)), got $(inds[1])"))
    nothing
end
checkdim1(::Type{C}, dims) where {C<:Color1} = nothing

parentaxes(::Type, inds) = tail(inds)
parentaxes(::Type{C}, inds) where {C<:Color1} = inds

celtype(::Type{Any}, ::Type{T}) where {T} = T
celtype(::Type{T1}, ::Type{T2}) where {T1,T2} = T1

## Low-level color utilities

tuplify(c::Color1) = (comp1(c),)
tuplify(c::Color3) = (comp1(c), comp2(c), comp3(c))
tuplify(c::Color2) = (comp1(c), alpha(c))
tuplify(c::Color4) = (comp1(c), comp2(c), comp3(c), alpha(c))

"""
    getchannels(P, C::Type, I)

Get a tuple of all channels needed to construct a Colorant of type `C`
from an `P::AbstractArray{<:Number}`.
"""
getchannels
@inline getchannels(P, ::Type{C}, I) where {C<:Color1} = (@inbounds ret = (P[I...],); ret)
@inline getchannels(P, ::Type{C}, I::Real) where {C<:Color1} = (@inbounds ret = (P[I],); ret)
@inline function getchannels(P, ::Type{C}, I) where C<:Color2
    @inbounds ret = (P[1,I...], P[2,I...])
    ret
end
@inline function getchannels(P, ::Type{C}, I) where C<:Color3
    @inbounds ret = (P[1,I...], P[2,I...],P[3,I...])
    ret
end
@inline function getchannels(P, ::Type{C}, I) where C<:Color4
    @inbounds ret = (P[1,I...], P[2,I...], P[3,I...], P[4,I...])
    ret
end

# setchannel (similar to setfield!)
# These don't check bounds since that's already done
"""
    setchannel(c, val, idx)

Equivalent to:

    cc = copy(c)
    cc[idx] = val
    cc

for immutable colors. `idx` is interpreted in the sense of constructor
arguments, so `setchannel(c, 0.5, 1)` would set red color channel for
any `c::AbstractRGB`, even if red isn't the first field in the type.
"""
setchannel(c::Colorant{T,1}, val, Ic::Int) where {T} = typeof(c)(val)

setchannel(c::TransparentColor{C,T,2}, val, Ic::Int) where {C,T} =
    typeof(c)(ifelse(Ic==1,val,comp1(c)),
              ifelse(Ic==2,val,alpha(c)))

setchannel(c::Colorant{T,3}, val, Ic::Int) where {T} = typeof(c)(ifelse(Ic==1,val,comp1(c)),
                                                          ifelse(Ic==2,val,comp2(c)),
                                                          ifelse(Ic==3,val,comp3(c)))
setchannel(c::TransparentColor{C,T,4}, val, Ic::Int) where {C,T} =
    typeof(c)(ifelse(Ic==1,val,comp1(c)),
              ifelse(Ic==2,val,comp2(c)),
              ifelse(Ic==3,val,comp3(c)),
              ifelse(Ic==4,val,alpha(c)))

"""
    setchannels!(P, val, I)

For a color `val`, distribute its channels along `P[:, I...]` for
`P::AbstractArray{<:Number}`.
"""
setchannels!
@inline setchannels!(P, val::Color1, I) = (@inbounds P[I...] = comp1(val); val)
@inline function setchannels!(P, val::Color2, I)
    @inbounds P[1,I...] = comp1(val)
    @inbounds P[2,I...] = alpha(val)
    val
end
@inline function setchannels!(P, val::Color3, I)
    @inbounds P[1,I...] = comp1(val)
    @inbounds P[2,I...] = comp2(val)
    @inbounds P[3,I...] = comp3(val)
    val
end
@inline function setchannels!(P, val::Color4, I)
    @inbounds P[1,I...] = comp1(val)
    @inbounds P[2,I...] = comp2(val)
    @inbounds P[3,I...] = comp3(val)
    @inbounds P[4,I...] = alpha(val)
    val
end

