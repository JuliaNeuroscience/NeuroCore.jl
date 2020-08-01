
module Nodes

using AxisIndices
using NamedDims
using FieldProperties
using GeometryBasics
using MetadataArrays
using NeuroCore.SpatialAPI
using NeuroCore.AnatomicalAPI

export PointNode, PointNodeList, MultiPointNodeList

"""
    CoordinateProperties
"""
struct CoordinateProperties{L,N,Ax,CS,P} <: AbstractPropertyList{P}
    sc::SpatialCoordinates{L,N,Ax,CS}
    properties::P
end

SpatialCoordinates(cp::CoordinateProperties) = getfield(cp, :sc)

FieldProperties.properties(cp::CoordinateProperties) = getfield(cp, :properties)

AxisIndices.axes_type(::Type{<:CoordinateProperties{L,N,Ax,CS,P}}) where {L,N,Ax,CS,P} = Ax

NamedDims.dimnames(::Type{<:CoordinateProperties{L,N,Ax,CS,P}}) where {L,N,Ax,CS,P} = L

Base.ndims(::Type{<:CoordinateProperties{L,N,Ax,CS,P}}) where {L,N,Ax,CS,P} = N

Base.axes(cp::CoordinateProperties) = axes(SpatialCoordinates(cp))

function SpatialAxes.coordinate_system(cp::CoordinateProperties)
    return coordinate_system(SpatialCoordinates(cp))
end

include("pointnodes.jl")

end
