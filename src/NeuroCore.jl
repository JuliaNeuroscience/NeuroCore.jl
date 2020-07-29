
module NeuroCore

using AxisIndices
using NamedDims
using TimeAxes
using FieldProperties
using StaticArrays
using GeometryBasics
using Mmap
using CoordinateTransformations
using LinearAlgebra
using Unitful
using Unitful: s, Hz, T, °, mm

using CoordinateTransformations: Rotations
using CoordinateTransformations.Rotations: SPQuat, Rotation

using Base: @propagate_inbounds

using Reexport

include("./ColorChannels/ColorChannels.jl")

include("./SpatialAPI/SpatialAPI.jl")
@reexport using .SpatialAPI

include("./AnatomicalAPI/AnatomicalAPI.jl")
using .AnatomicalAPI
@reexport using .AnatomicalAPI

#include("./Nodes/Nodes.jl")
#using .Nodes
#@reexport using .Nodes

include("./swapstream.jl")
using .SwapStreams
@reexport using .SwapStreams

include("./NeuroMetadata/NeuroMetadata.jl")
using .NeuroMetadata

const F64Second = typeof(one(Float64) * s)
const F64Tesla = typeof(one(Float64) * T)
const F64kOhms = typeof(1.0u"kΩ")
const F64Hertz = typeof(one(Float64) * Hz)
const IntDegree = typeof(1 * °)

include("io.jl")

"""
    CoordinateSpace

Returns an instance of `CoordinateSystem` describing the coordinate system for `x`.
"""
struct CoordinateSpace{S}
    space::S
end

const UnkownCoordinatesSpace = CoordinateSpace(nothing)

coordinate_space(x) = UnkownCoordinatesSystem

#= TODO formalize this interaction
CoordinateSpace(sc::MetadataArray{T,N,<:CoordinateSystem}) = metadata(sc)

CoordinateSpace(sc::AbstractAxisArray) = (parent(sc))

CoordinateSpace(sc::NamedDimsArray) = (parent(sc))
=#

# TODO document SpatialCoordinates
"""
    SpatialCoordinates

"""
const SpatialCoordinates{L,CS,N,Axs} = NamedMetaCartesianAxes{L,N,CoordinateSpace{CS},Axs}

function SpatialCoordinates(x)
    return NamedMetaCartesianAxes{spatial_order(x)}(spatial_axes(x), metadata=CoordinateSpace(x))
end

#= TODO Is this a good name for this
"The anatomical coordinate system."
@defprop AnatomicalSystem{:anatsystem}

"The acquisition coordinate system."
@defprop AcquisitionSystem{:acqsystem}
=#

end
