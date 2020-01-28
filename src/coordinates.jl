@enum CoordinateSystemName begin
    Acquisition
    Anatomical
    ICBM
    IXI
    MNI152
    NIHPD
    Tailarach
end

"""
    CoordinateMetadata
"""
struct CoordinateMetadata{CS<:CoordinateSystemName,U,M} <: AbstractMetadata{M}
    coordinate_system::CS
    units::U
    meta::M
end

"""
    NeuroCoordinates
"""
const NeuroCoordinates{T,A<:AbstractVector{T},ROIS,M<:CoordinateMetadata} = AxisArray{T,1,ImageMeta{T,1,A,M},Tuple{ROIS}}

function NeuroCoordinates(
    coordinates::AbstractVector{NTuple{3}},
    rois::AbstractVector{Symbol},
    meta::CoordinateMetadata
)
    return AxisArray(ImageMeta(coordinates, meta), Axis{:rois}(rois))
end
