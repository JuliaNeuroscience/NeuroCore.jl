
"""
    AnatomicalAxes

Defines axes specific methods related to anatomical data, including sagittal,
axial, and coronal axes.
"""
module AnatomicalAxes

using LinearAlgebra
using Unitful
using AxisIndices
using NamedDims
using NeuroCore.SpatialAxes
using Base: tail

export
    is_anatomical,
    is_radiologic,
    is_neurologic,
    # sagittal
    is_sagittal,
    sagittaldim,
    has_sagittaldim,
    sagittal_axis,
    sagittal_axis_type,
    sagittal_keys,
    sagittal_indices,
    nsagittal,
    select_sagittaldim,
    # axial
    is_axial,
    axialdim,
    has_axialdim,
    axial_axis,
    axial_axis_type,
    axial_keys,
    axial_indices,
    naxial,
    select_axialdim,
    # coronal
    is_coronal,
    coronaldim,
    has_coronaldim,
    coronal_axis,
    coronal_axis_type,
    coronal_keys,
    coronal_indices,
    ncoronal,
    select_coronaldim,
    # encoding directions
    EncodingDirection,
    encoding_name,
    dir2ord

include("dimnames.jl")

AxisIndices.@defdim sagittal is_sagittal

AxisIndices.@defdim axial is_axial

AxisIndices.@defdim coronal is_coronal

include("encoding_directions.jl")
include("dir2ord.jl")
include("coordinate_systems.jl")

end

