module NeuroCore

using Images
using NamedDims
using StaticArrays, CoordinateTransformations, LinearAlgebra
using Unitful
using Unitful: s, Hz, T, °, mm
using FieldProperties

using CoordinateTransformations: Rotations
using CoordinateTransformations.Rotations: SPQuat, Rotation

export
    NeuroArray,
    NeuroCoordinates,
    CoordinateMetadata,
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
    spatialorder,
    dimnames,
    dim

include("units.jl")
include("./SemanticPositions/SemanticPositions.jl")
using .SemanticPositions

include("dimensions.jl")
include("./Orientation/Orientation.jl")
include("hardware.jl")
include("institution.jl")
include("enums.jl")
include("traits.jl")
include("./Imaging/Imaging.jl")
include("./Electrophysiology/Electrophysiology.jl")
include("coordinates.jl")

fxntmp(;kwargs...) = kwargs

end
