@enum CoordinateSystemName begin
    Acquisition
    Anatomical
    ICBM
    IXI
    MNI152
    NIHPD
    Tailarach
    UnkownCoordinateSystem
end

"""
    CoordinateMetadata

Metadata for a set of coordinates.
"""
struct CoordinateMetadata{CS<:CoordinateSystemName,U,M} <: AbstractMetadata{M}
    coordinate_system::CS
    units::U
    meta::M
end
FieldProperties.dictextension(m::CoordinateMetadata) = getfield(m, :meta)

function CoordinateMetadata(coordinate_system=UnkownCoordinateSystem, units=mm, meta=Metadata())
    return CoordinateMetadata(coordinate_system, units, meta)
end

"""
    NeuroCoordinates

## Examples
```jldoctest
julia> using NeuroCore

julia> x = NeuroCoordinates([(1,1,1), (1,1,2)], [:roi1, :roi2]);
```
"""
const NeuroCoordinates{T,A<:AbstractVector{T},ROIS,M<:CoordinateMetadata} = ImageMeta{T,1,AxisArray{T,1,A,Tuple{ROIS}},M}

function NeuroCoordinates(
    coordinates::AbstractVector,
    rois::AbstractVector{Symbol},
    meta::CoordinateMetadata=CoordinateMetadata()
)
    return ImageMeta(AxisArray(coordinates, (Axis{:rois}(rois),)), meta)
end
