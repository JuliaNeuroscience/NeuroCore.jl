
struct OrientationMetadata{names,U,T,N,R<:CoordinateTransformations.Rotations.Rotation{N,T},M} <: AbstractMetadata{M}
    affine_map::AffineMap{R,NTuple{N,T}}
    pixelspacing::NTuple{N,T}
    meta::M
end

const AbstractQuat{T} = Union{Quat{T},SPQuat{T}}

const QuatMap{names,U,T,N,R<:AbstractQuat{T},M} = OrientationMetadata{names,U,T,N,R,M}

NamedDims.dimnames(::Type{<:OrientationMetadata{names}}) where {names} = names

ImageCore.pixelspacing(m::OrientationMetadata) = m.pixelspacing

Base.ndims(::Type{<:OrientationMetadata{names,U,T,N}}) where {names,U,T,N} = N

@properties OrientationMetadata begin
    pixelspacing(self) => :pixelspacing
    affine_map(self) => :affine_map
    linear(self) -> self.affine_map.linear
    translation(self) -> self.affine_map.translation
    Any(self) => :meta
    Any!(self, val) => :meta
end

include("polar.jl")
include("affinemap.jl")
include("spatialorder.jl")
include("quat2mat.jl")
include("mat2quat.jl")
include("coordinate_systems.jl")

