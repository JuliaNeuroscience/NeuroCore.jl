module NeuroCore

using Images
using NamedDims
using StaticArrays, CoordinateTransformations, LinearAlgebra
using Unitful
using Unitful: s, Hz, T, °
using FieldProperties

using CoordinateTransformations: Rotations
using CoordinateTransformations.Rotations: SPQuat, Rotation

export
    NeuroArray,
    InstitutionInformation,
    HardwareMetadata,
    EncodingDirectionMetadata,
    OrientationMetadata,
    # Orientation
    affine_map,
    # methods
    sagittaldim,
    coronaldim,
    axialdim,
    indices_sagittal,
    indices_axial,
    indices_coronal,
    is_radiologic,
    is_neurologic,
    # reexprots
    dimnames,
    dim

"second_type(x) - Returns the type used for seconds given `x`."
second_type(x) = typeof(one(Float64) * s)

"tesla_type(x) - Returns the type used for tesla given `x`."
tesla_type(x) = typeof(one(Float64) * T)

"hertz_type(x) - Returns the type used for hertz given `x`."
hertz_type(x) = typeof(one(Float64) * Hz)

"degree_type(x) - Returns the type used for hertz given `x`."
degree_type(x) = typeof(1 * °)

"ohms_type(x) - Returns the type used for ohms given `x`."
ohms_type(x) = typeof(1.0u"kΩ")

const NeuroArray{T,N,A<:AbstractArray{T,N},M<:AbstractMetadata,Ax} = ImageMeta{T,N,AxisArray{T,N,A,Ax},M}

NeuroArray(a::AbstractArray, axs; kwargs...) = NeuroArray(a, axs, Metadata(; kwargs...))
NeuroArray(a::AbstractArray, axs, m::AbstractMetadata) = ImageMeta(AxisArray(a, nt2axis(axs)), m)

nt2axis(axs::NamedTuple{name}) where {name} = (Axis{first(name)}(first(axs)), nt2axis(Base.tail(axs))...)
nt2axis(axs::NamedTuple{(),Tuple{}}) = ()
nt2axis(axs::Tuple{Vararg{<:Axis}}) = axs

include("./SemanticPositions/SemanticPositions.jl")
using .SemanticPositions

include("axes.jl")
include("./Orientation/Orientation.jl")
include("hardware.jl")
include("institution.jl")
include("enums.jl")
include("traits.jl")
include("./Imaging/Imaging.jl")
include("./Electrophysiology/Electrophysiology.jl")
include("coordinates.jl")

end
