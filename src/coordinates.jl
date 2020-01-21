# TODO document coordinates
"""

"""
@defprop Coordinates{:coordinates}

const NeuroCoordinates{T<:AbstractPoint,A<:AbstractVector{T},M} = NeuroArray{T,1,A,M}

# TODO Does it make sense ot separate out CoordinateMetadata with name/indices/etc?
"""
    CoordinateList

Consists of three fields:
* `coordinates::AbstractVector`:
* `spatial_indices::Tuple`:
* `meta::AbstractMetadata`:

"""
struct CoordinateList{T<:AbstractPoint,C<:AbstractVector{T},Ax<:Tuple,M<:AbstractMetadata} <: AbstractVector{T}
    coordinates::C
    indices_spatial::Ax
    meta::M
end

"""
    coordinates(cs::CoordinateList)

Corresponds to BIDS "*Coordinates" fields.
"""
GeometryBasics.coordinates(cs::CoordinateList) = getfield(cs, :coordinates)

@assignprops(
    NeuroCoordinates,
    :name => name,
    :indices_spatial => indices_spatial,
    :meta => dictextension
)
