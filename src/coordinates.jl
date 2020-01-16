# TODO Does it make sense ot separate out CoordinateMetadata with name/indices/etc?
"""
    CoordinateList

Consists of three fields:
* `coordinates::AbstractVector`:
* `spatial_indices::Tuple`:
* `properteis::AbstractMetadata`:

"""
struct CoordinateList{T<:AbstractPoint,C<:AbstractVector{T},Ax<:Tuple,M<:AbstractDict{Symbol,Any}} <: AbstractVector{T}
    name::Symbol
    coordinates::C
    indices_spatial::Ax
    metadata::M
end

ImageCore.indices_spatial(cs::CoordinateList) = getfield(cs, :indices_spatial)

"""
    coordinates(cs::CoordinateList)

Corresponds to BIDS "*Coordinates" fields.
"""
GeometryBasics.coordinates(cs::CoordinateList) = getfield(cs, :coordinates)

"""
    spatial_units(cs::CoordinateList)

Corresponds to BIDS "*CoordinateUnits" fields.
"""
spatial_units(cs::CoordinateList) = spatial_units(indices_spatial(cs))

@assignprops(
    NeuroCoordinates,
    name => Name,
    metadata => DictExtension(Description)
)
