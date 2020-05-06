module NeuroCore

using AxisIndices
using NamedDims
using TimeAxes
using FieldProperties
using MetadataArrays
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

export NAPArray, PointNode, NodeFiber, properties

include("./SpatialAxes/SpatialAxes.jl")
using .SpatialAxes
@reexport using .SpatialAxes

include("./AnatomicalAxes/AnatomicalAxes.jl")
using .AnatomicalAxes
@reexport using .AnatomicalAxes

include("./NeuroMetadata/NeuroMetadata.jl")
using .NeuroMetadata

const F64Second = typeof(one(Float64) * s)
const F64Tesla = typeof(one(Float64) * T)
const F64kOhms = typeof(1.0u"kΩ")
const F64Hertz = typeof(one(Float64) * Hz)
const IntDegree = typeof(1 * °)

include("arrays.jl")
include("nodes.jl")
include("io.jl")

end
