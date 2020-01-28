module NeuroCore

using Images
using NamedDims
using StaticArrays, CoordinateTransformations, LinearAlgebra
using Unitful
using FieldProperties

using CoordinateTransformations: Rotations
using Rotations: SPQuat, Rotation

export
    NeuroArray,
    InstitutionInformation,
    HardwareMetadata,
    EncodingDirectionMetadata

"second_type(x) - Returns the type used for seconds given `x`."
second_type(x) = typeof(one(Float64) * Unitful.s)

"tesla_type(x) - Returns the type used for tesla given `x`."
tesla_type(x) = typeof(one(Float64) * Unitful.T)

"hertz_type(x) - Returns the type used for hertz given `x`."
hertz_type(x) = typeof(one(Float64) * Unitful.Hz)

"degree_type(x) - Returns the type used for hertz given `x`."
degree_type(x) = typeof(1 * Unitful.°)

"ohms_type(x) - Returns the type used for ohms given `x`."
ohms_type(x) = typeof(1.0u"kΩ")

const NeuroArray{T,N,A<:AbstractArray{T,N},M<:AbstractMetadata,Ax} = AxisArray{T,N,ImageMeta{T,N,A,M},Ax}

function NeuroArray(a::AbstractArray, axs::NamedTuple; kwargs...)
    return NeuroArray(a, axs, Metadata(; kwargs...))
end
function NeuroArray(a::AbstractArray, axs::NamedTuple, m::AbstractMetadata)
    return AxisArray(ImageMeta(a, m), nt2axis(axs))
end

nt2axis(axs::NamedTuple{name}) where {name} = (Axis{first(name)}(first(axs)), tail(axs)...)
nt2axis(axs::NamedTuple{(),Tuple{}}) = ()

@assignprops(NeuroArray, properties => nested_property)

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
