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

julia> NeuroCoordinates([(1,2,3), (1,2,3)], [:roi1, :roi2])
Tuple ImageMeta with:
  data: 1-dimensional AxisArray{Tuple{Int64,Int64,Int64},1,...} with axes:
    :rois, Symbol[:roi1, :roi2]
And data, a 2-element Array{Tuple{Int64,Int64,Int64},1}
  properties:

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
