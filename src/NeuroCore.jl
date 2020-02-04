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
    # Units
    second_type,
    tesla_type,
    hertz_type,
    degree_type,
    ohms_type,
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

include("units.jl")
include("./SemanticPositions/SemanticPositions.jl")
using .SemanticPositions

const NeuroArray{T,N,A<:AbstractArray{T,N},M<:AbstractMetadata,Ax} = ImageMeta{T,N,AxisArray{T,N,A,Ax},M}

NeuroArray(a::AbstractArray, axs; kwargs...) = NeuroArray(a, axs, Metadata(; kwargs...))
NeuroArray(a::AbstractArray, axs, m::AbstractMetadata) = ImageMeta(AxisArray(a, nt2axis(axs)), m)

nt2axis(axs::NamedTuple{name}) where {name} = (Axis{first(name)}(first(axs)), nt2axis(Base.tail(axs))...)
nt2axis(axs::NamedTuple{(),Tuple{}}) = ()
nt2axis(axs::Tuple{Vararg{<:Axis}}) = axs

include("dimensions.jl")
include("./Orientation/Orientation.jl")
include("hardware.jl")
include("institution.jl")
include("enums.jl")
include("traits.jl")
include("./Imaging/Imaging.jl")
include("./Electrophysiology/Electrophysiology.jl")
include("coordinates.jl")

end
