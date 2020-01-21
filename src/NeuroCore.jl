module NeuroCore

using Images
using NamedDims
using StaticArrays, Rotations, CoordinateTransformations
using Unitful
using FieldProperties

export NeuroArray

const OneF64Sec = 1.0u"s"
"F64Sec - A `Float64` type with seconds units."
const F64Sec = typeof(OneF64Sec)

const OneF64Tesla = 1.0u"T"
"F64Tesla - A `Float64` type with tesla units."
const F64Tesla = typeof(OneF64Tesla)

const OneF64Hz = 1.0u"Hz"
"F64Hertz - A `Float64` type with hertz units."
const F64Hz = typeof(OneF64Hz)

const OneIntDeg = 1.0u"°"
"IntDeg - A `Float64` type with degree units."
const IntDeg = typeof(OneIntDeg)

const OnekOhm = 1.0u"kΩ"
const F64kOhm = typeof(OnekOhm)

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

include("enums.jl")
include("traits.jl")
include("./Imaging/Imaging.jl")
include("./Electrophysiology/Electrophysiology.jl")
include("axes.jl")
include("orientation.jl")

end
