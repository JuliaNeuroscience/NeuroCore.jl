"""
    is_spatial_axis(ni::Index) -> Bool

Determines whether a given axis refers to a spatial dimension. Default is true.
"""
is_spatial_axis(::T) where {T} = is_spatial_axis(T)
is_spatial_axis(::Type{<:AbstractIndex{name}}) where {name} = true
is_spatial_axis(::Type{<:AbstractIndex{:time}}) = false
is_spatial_axis(::Type{<:AbstractIndex{:color}}) = false


ImageCore.coords_spatial(a::ImageArray) = find_axes(is_spatial_axis, a)

ImageCore.indices_spatial(a::ImageArray) = filter_axes(is_spatial_axis, a)

ImageCore.sdims(x::ImageArray) = count(is_spatial_axis, axes(x))

ImageCore.size_spatial(x::ImageArray) = map(i -> length(x, i), indices_spatial(x))

ImageCore.pixelspacing(img::ImageArray) = map(i -> step(x, i), indices_spatial(x))

ImageCore.spacedirections(img::ImageArray) = spacedirections(namedaxes(img))

"""
    spatial_offset(img)

Provides the offset of each dimension (i.e., where each spatial axis starts).
"""
spatial_offset(x) = first.(coords_indices(x))


"""
    spatial_units(img)

Returns the units (i.e. Unitful.unit) that each spatial axis is measured in. If not
available `nothing` is returned for each spatial axis.
"""
spatial_units(x) = unit.(eltype.(filter_axes(is_spatial_axis, x)))

spatial_units(x::ImageMeta) = map(i->unit(eltype(i)), pixelspacing(x))

"""
    freqdim(x) -> Int

Which spatial dimension (1, 2, or 3) corresponds to phase acquisition. If not
applicable to scan type defaults to `0`.
"""
freqdim(x) = getter(x, "freqdim", Int, 0)

"""
    freqdim!(x, val)

Set the frequency dimension of `x` to `val`.
"""
freqdim!(x, val) = setter!(x, "freqdim", Int, val)

"""
    slicedim(x) -> Int

Which dimension slices where acquired at throughout MRI acquisition.
"""
slicedim(x) = getter(x, "slicedim", Int, x -> 0)

"""
    slicedim!(x, val)

Set the slice dimension of `x` to `val`.
"""
slicedim!(x, val) = setter!(x, "slicedim", Int, val)

"""
    phasedim(x) -> Int

Which spatial dimension (1, 2, or 3) corresponds to phase acquisition.
"""
phasedim(x) = getter(x, "phasedim", Int, x -> 0)

"""
    phasedim!(x, val)

Set the slice dimension of `x` to `val`.
"""
phasedim!(x, val) = setter!(x, "phasedim", Int, val)

"""
    slice_start(x) -> Int

Which slice corresponds to the first slice acquired during MRI acquisition
(i.e. not padded slices). Defaults to `1`.
"""
slice_start(x) = getter(x, "slice_start", Int, x -> 0)

"""
    slice_start!(x, val)

Set the first slice acquired during the MRI acquisition.
"""
slice_start!(x, val) = setter!(x, "slice_start", Int, val)

"""
    slice_end(x) -> Int

Which slice corresponds to the last slice acquired during MRI acquisition
(i.e. not padded slices).
"""
slice_end(x) = getter(x, "slice_end", Int, x -> 1)

"""
    slice_end!(x, val)

Set the last slice acquired during the MRI acquisition.
"""
slice_end!(x, val) = setter!(x, "slice_end", Int, val)

"""
    slice_duration(x) -> Float64

The amount of time necessary to acquire each slice throughout the MRI
acquisition.
"""
slice_duration(x) = getter(x, "slice_duration", Float64, x -> one(Float64))

"""
    slice_duration!(x, val)

Set the slice_duration of `x` to `val`.
"""
slice_duration!(x, val) = setter!(x, "slice_duration", Float64, val)
