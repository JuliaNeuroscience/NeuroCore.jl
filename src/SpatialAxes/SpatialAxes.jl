module SpatialAxes

using NamedDims
using StaticRanges
using AxisIndices
using FieldProperties
using MetadataArrays

export
    # Types
    CoordinateSystem,
    SpatialCoordinates,
    # methods
    spatial_order,
    spatialdims,
    spatial_axes,
    spatial_offset,
    spatial_keys,
    spatial_indices,
    spatial_size,
    pixel_spacing,
    spatial_directions,
    sdims,
    coordinate_system


const NOT_SPATIAL = (:time,:color,:observation)

Base.@pure is_spatial(x::Symbol) = !Base.sym_in(x, NOT_SPATIAL)

"""
    spatial_order(x) -> Tuple{Vararg{Symbol}}

Returns the `dimnames` of `x` that correspond to spatial dimensions.
"""
spatial_order(x::X) where {X} = _spatial_order(Val(dimnames(X)))
@generated function _spatial_order(::Val{L}) where {L}
    keep_names = []
    i = 1
    itr = 0
    while (itr < 3) && (i <= length(L))
        n = getfield(L, i)
        if is_spatial(n)
            push!(keep_names, n)
            itr += 1
        end
        i += 1
    end
    quote
        return $(keep_names...,)
    end
end



"""
    spatialdims(x) -> Tuple{Vararg{Int}}

Return a tuple listing the spatial dimensions of `img`.
Note that a better strategy may be to use ImagesAxes and take slices along the time axis.
"""
@inline spatialdims(x) = dim(dimnames(x), spatial_order(x))

"""
    spatial_axes(x) -> Tuple

Returns a tuple of each axis corresponding to a spatial dimensions.
"""
@inline spatial_axes(x) = _spatial_axes(named_axes(x), spatial_order(x))
function _spatial_axes(na::NamedTuple, spo::Tuple{Vararg{Symbol}})
    return map(spo_i -> getfield(na, spo_i), spo)
end

"""
    spatial_size(x) -> Tuple{Vararg{Int}}

Return a tuple listing the sizes of the spatial dimensions of the image.
"""
@inline spatial_size(x) = map(length, spatial_axes(x))

"""
    spatial_indices(x)

Return a tuple with the indices of the spatial dimensions of the
image. Defaults to the same as `indices`, but using `NamedDimsArray` you can
mark some axes as being non-spatial.
"""
@inline spatial_indices(x) = map(values, spatial_axes(x))

"""
    spatial_keys(x)
"""
@inline spatial_keys(x) = map(keys, spatial_axes(x))

# FIXME account for keys with no steps
"""
    pixel_spacing(x)

Return a tuple representing the separation between adjacent pixels along each axis
of the image. Derived from the step size of each element of `spatial_keys`.
"""
@inline function pixel_spacing(x)
    map(spatial_keys(x)) do ks_i
        if StaticRanges.has_step(ks_i)
            return step(ks_i)
        else
            return 0
        end
    end
end

"""
    spatial_offset(x)

The offset of each dimension (i.e., where each spatial axis starts).
"""
spatial_offset(x) = map(first, spatial_keys(x))

"""
    spatial_directions(x) -> (axis1, axis2, ...)

Return a tuple-of-tuples, each `axis[i]` representing the displacement
vector between adjacent pixels along spatial axis `i` of the image
array, relative to some external coordinate system ("physical
coordinates").

By default this is computed from `pixel_spacing`, but you can set this
manually using ImagesMeta.
"""
@defprop SpatialDirections{:spatial_directions} begin
    @getproperty x -> _spatial_directions(x, spatialdims(x))
end

function _spatial_directions(x::AbstractArray, spatdims::NTuple{N,Int}) where {N}
    ntuple(Val(N)) do j
        ntuple(Val(N)) do i
            if j === i
                ks = axes_keys(x, getfield(spatdims, i))
                if StaticRanges.has_step(ks)
                    return step(ks)
                else
                    return 1  # TODO If keys are not range does it make sense to return this?
                end
            else
                return 0
            end
        end
    end
    #=
    ntuple(Val(N)) do i
        ntuple(Val(N)) do d
            if d === i
                if is_spatial(dimnames(x, i))
                    ks = axes_keys(x, i)
                    if StaticRanges.has_step(ks)
                        return step(ks)
                    else
                        return 1  # TODO If keys are not range does it make sense to return this?
                    end
                else
                    return 0
                end
            else
                return 0
            end
        end
    end
    =#
end

"""
    sdims(x)

Return the number of spatial dimensions in the image. Defaults to the same as
`ndims`, but with `NamedDimsArray` you can specify that some dimensions correspond
to other quantities (e.g., time) and thus not included by `sdims`.
"""
@inline function sdims(x)
    cnt = 0
    for name in dimnames(x)
        if is_spatial(name)
            cnt += 1
        end
    end
    return cnt
end

"""
    affine_map
"""
function affine_map(x)
    return AffineMap(_spatial_directions_to_rotation(RotMatrix, spatial_directions(x)),
                     _pixelspacing_to_linearmap(pixel_spacing(x)))
end

function _pixelspacing_to_linearmap(ps::NTuple{2,T}) where {T}
    return @inbounds LinearMap(SVector(Float64(ps[1]), Float64(ps[2]), 0.0))
end

function _pixelspacing_to_linearmap(ps::NTuple{3,T}) where {T}
    return @inbounds LinearMap(SVector(Float64(ps[1]), Float64(ps[2]), Float64(ps[3])))
end

function _spatial_directions_to_rotation(::Type{R}, sd::NTuple{2,NTuple{2,T}}) where {R,T}
    return @inbounds R(SMatrix{3,3,Float64,9}(
        sd[1][1], sd[2][1], 0,
        sd[1][2], sd[2][2], 0,
               0,        0, 1)
    )
end

function _spatial_directions_to_rotation(::Type{R}, sd::NTuple{3,NTuple{3,T}}) where {R,T}
    return @inbounds R(SMatrix{3,3,Float64,9}(
        sd[1][1], sd[2][1], sd[3][1],
        sd[1][2], sd[2][2], sd[3][2],
        sd[1][3], sd[2][3], sd[3][3])
    )
end


# TODO Is this a good name for this
"The anatomical coordinate system."
@defprop AnatomicalSystem{:anatsystem}

"The acquisition coordinate system."
@defprop AcquisitionSystem{:acqsystem}


"""
    CoordinateSystem
"""
struct CoordinateSystem{CS}
    coordinate_system::CS
end

const UnkownCoordinatesSystem = CoordinateSystem(nothing)

"""
    coordinate_system(x) -> CoordinateSystem
"""
coordinate_system(x) = UnkownCoordinatesSystem

"""
    SpatialCoordinates{L,N,Ax,Cs}
"""
const SpatialCoordinates{L,N,Ax,CS} = NamedDimsArray{L,Int,N,MetadataArray{Int,N,CartesianAxes{N,Ax},CoordinateSystem{CS}}}

function SpatialCoordinates(x)
    return NamedDimsArray{dimnames(x)}(
        MetadataArray(
            CartesianIndices(spatial_axes(x)),
            coordinate_system(x)
        )
    )
end

end
