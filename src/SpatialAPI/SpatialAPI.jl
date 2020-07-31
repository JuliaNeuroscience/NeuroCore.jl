"""
    SpatialAPI

Module responsible for defining core methods for accessing and manipulating spatial
components data structures in Julia.
"""
module SpatialAPI

using AxisIndices
using AxisIndices.ObservationDims
using AxisIndices.Interface: NamedDimsArray

using MappedArrays
using MappedArrays: AbstractMultiMappedArray, AbstractMappedArray

using GeometryBasics
using TimeAxes

using NeuroCore.ColorChannels
using NeuroCore.ColorChannels: ZeroArray, is_channel

using Base: tail

export
    height,
    pixel_spacing,
    sdims,
    spatialdims,
    spatial_axes,
    spatial_indices,
    spatial_keys,
    spatial_size,
    spatial_directions,
    spatial_order,
    width,
    width_height

widths_height(img::AbstractArray) = (widths(img), height(img))

GeometryBasics.width(img::AbstractArray) = size(img, 2)

GeometryBasics.height(img::AbstractArray) = size(img, 1)

# yes this abuses @pure but each of these is a pure method and it's the only way I
# could get names to propagate through other operations.
Base.@pure function is_spatial(x::Symbol)
    return !(is_time(x) || is_observation(x) || is_channel(x))
end

"""
    spatial_order(x) -> Tuple{Vararg{Symbol}}

Returns the `dimnames` of `x` that correspond to spatial dimensions.
"""
@inline function spatial_order(::T) where {T}
    if has_dimnames(T)
        return _spatial_order(Val(dimnames(T)))
    else
        return AxisIndices.Interface.default_names(Val(min(3, ndims(T))))
    end
end

@generated function _spatial_order(::Val{L}) where {L}
    keep_names = Symbol[]
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
@inline function spatialdims(x::T) where {T}
    if has_dimnames(x)
        return _spatialdims(Val(dimnames(x)))
    else
        return ntuple(+, Val(min(ndims(T), 3)))
    end
end

spatialdims(img::AbstractMappedArray) = spatialdims(parent(img))
function spatialdims(img::AbstractMultiMappedArray)
    ps = traititer(spatialdims, parent(img)...)
    checksame(ps)
end
# TODO remove spatialdims(img::OffsetArray) = coords_spatial(parent(img))
@inline spatialdims(img::SubArray) =
    _subarray_offset(0, spatialdims(parent(img)), img.indices...)
@inline function spatialdims(img::Base.PermutedDimsArrays.PermutedDimsArray{T,N,perm,iperm}) where {T,N,perm,iperm}
    return _getindex_tuple(spatialdims(parent(img)), iperm)
end

@generated function _spatialdims(::Val{L}) where {L}
    keep_names = Int[]
    i = 1
    itr = 0
    while (itr < 3) && (i <= length(L))
        if is_spatial(getfield(L, i))
            push!(keep_names, i)
            itr += 1
        end
        i += 1
    end
    quote
        return $(keep_names...,)
    end
end

"""
    spatial_axes(x) -> Tuple

Returns a tuple of each axis corresponding to a spatial dimensions.
"""
#l@inline spatial_axes(x) = map(i -> axes(x, i), spatialdims(x))
@inline spatial_axes(x) = _filter_axes(named_axes(x), spatial_order(x))

@inline function _filter_axes(naxs::NamedTuple, d::Tuple{Vararg{Any,N}}) where {N}
    return ntuple(i -> getfield(naxs, getfield(d, i)), Val(N))
end

"""
    spatial_size(x) -> Tuple{Vararg{Int}}

Return a tuple listing the sizes of the spatial dimensions of the image.
"""
@inline spatial_size(x) =  map(i -> size(x, i), spatialdims(x))
spatial_size(img::AbstractMappedArray) = size_spatial(parent(img))
function spatial_size(img::AbstractMultiMappedArray)
    ps = traititer(spatial_size, parent(img)...)
    checksame(ps)
end
# TODO remove spatial_size(img::OffsetArray) = size_spatial(parent(img))
@inline spatial_size(img::SubArray) =
    _subarray_filter(spatial_size(parent(img)), img.indices...)
@inline function spatial_size(img::Base.PermutedDimsArrays.PermutedDimsArray{T,N,perm,iperm}) where {T,N,perm,iperm}
    return _getindex_tuple(spatial_size(parent(img)), iperm)
end

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

"""
    pixel_spacing(x)

Return a tuple representing the separation between adjacent pixels along each axis
of the image. Derived from the step size of each element of `spatial_keys`.
"""
@inline function pixel_spacing(x)
    map(spatial_keys(x)) do ks_i
        if AxisIndices.StaticRanges.has_step(ks_i)
            return step(ks_i)
        else
            return 1
        end
    end
end

"""
    spatial_offset(x)

The offset of each dimension (i.e., where each spatial axis starts).
"""
spatial_offset(x) = map(first, spatial_keys(x))


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
    affine_map(x) -> AffineMap

Returns and affine map. By default using `spatial_directions` and `pixel_spacing`
are used to constuct the mapping.
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

"""
    spatial_directions(img) -> (axis1, axis2, ...)

Return a tuple-of-tuples, each `axis[i]` representing the displacement
vector between adjacent pixels along spatial axis `i` of the image
array, relative to some external coordinate system ("physical
coordinates").

By default this is computed from `pixel_spacing`, but you can set this
manually using ImagesMeta.
"""
spatial_directions(img::AbstractArray) = _spatial_directions(pixel_spacing(img))

# FIXME
spatial_directions(img::AbstractMappedArray) = spatial_directions(parent(img))
function spatial_directions(img::AbstractMultiMappedArray)
    ps = traititer(spatial_directions, parent(img)...)
    checksame(ps)
end
@inline function spatial_directions(img::SubArray)
    return _subarray_filter(spatial_directions(parent(img)), getfield(img, :indices)...)
end

@inline function spatial_directions(img::Base.PermutedDimsArray{T,N,perm}) where {T,N,perm}
    return _getindex_tuple(spatial_directions(parent(img)), perm)
end

function _spatial_directions(ps::NTuple{N,Any}) where N
    return ntuple(i->ntuple(d->d==i ? ps[d] : zero(ps[d]), Val(N)), Val(N))
end

@inline _subarray_filter(x, i::Real, inds...) =
    _subarray_filter(tail(x), inds...)
@inline _subarray_filter(x, i, inds...) =
    (x[1], _subarray_filter(tail(x), inds...)...)
_subarray_filter(x::Tuple{}) = ()

@inline _subarray_offset(off, x, i::Real, inds...) =
    _subarray_offset(off-1, tail(x), inds...)
@inline _subarray_offset(off, x, i, inds...) =
    (x[1]+off, _subarray_offset(off, tail(x), inds...)...)
_subarray_offset(off, x::Tuple{}) = ()

@inline _getindex_tuple(t::Tuple, inds::Tuple) =
    (t[first(inds)], _getindex_tuple(t, tail(inds))...)
_getindex_tuple(t::Tuple, ::Tuple{}) = ()

@inline traititer(f, A, rest...) = (f(A), traititer(f, rest...)...)
@inline traititer(f, A::ZeroArray, rest...) = traititer(f, rest...)
traititer(f) = ()

function checksame(t::Tuple)
    val1 = t[1]
    @assert all(p -> p == val1, t)
    return val1
end


###
### Deprecations
###

# deprecations since "The Great Refactoring"

@deprecate pixelspacing pixel_spacing

@deprecate spacedirections spatial_directions

@deprecate coords_spatial spatialdims

@deprecate indices_spatial spatial_axes

@deprecate size_spatial spatial_size

@deprecate spatialorder spatial_order

@deprecate namedaxes named_axes

@deprecate nimages ntime

end
