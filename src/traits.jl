"""
    calmax(x)

Specifies maximum element for display purposes. Defaults to the maximum of `x`.
"""
calmax(x::Any) = getter(x, :calmax, i -> _caltype(x), i -> _calmax(i))
calmax!(x::Any, val::Any) = setter!(x, :calmax, val, i -> _caltype(i))

"""
    calmin(x)

Specifies minimum element for display purposes. Defaults to the minimum of `x`.
"""
calmin(x) = getter(x, :calmin, i -> _caltype(i), i -> _calmin(i))
calmin!(x, val) = setter!(x, :calmin, val, i -> _caltype(i))

###
_caltype(x::AbstractArray{T}) where {T} = T
_caltype(x::Any) = Float64
_calmax(x::AbstractArray) = maximum(x)
_calmax(x::Any) = one(Float64)
_calmin(x::AbstractArray) = minimum(x)
_calmin(x::Any) = one(Float64)

"""
    description(x) -> String

Retrieves description field that may say whatever you like.
"""
description(x) = getter(x, "description", String, i -> "")
description!(x, val) = setter!(x, "description", String, val)

"""
    freqdim(x) -> Int

Which spatial dimension (1, 2, or 3) corresponds to phase acquisition. If not
applicable to scan type defaults to `1`.
"""
freqdim(x) = getter(x, :freqdim, Int, 1)
freqdim!(x, val) = setter!(x, :freqdim, Int, val)

"""
    is_anatomical(::T) -> Bool

Returns `true` if `T` represents anatomical data.
"""
is_anatomical(::T) where {T} = is_anatomical(T)
is_anatomical(::Type{T}) where {T} = false

"""
    is_electrophysiology(::T) -> Bool

Returns `true` if `T` represents electrophysiology data.
"""
is_electrophysiology(::T) where {T} = is_electrophysiology(T)
is_electrophysiology(::Type{T}) where {T} = false

"""
    is_functional(::T) -> Bool

Returns `true` if `T` represents functional data.
"""
is_functional(::T) where {T} = is_functional(T)
is_functional(::Type{T}) where {T} = false
"""
    phasedim(x) -> Int

Which spatial dimension (1, 2, or 3) corresponds to phase acquisition.
"""
phasedim(x) = getter(x, :phasedim, Int, i -> 1)
phasedim!(x, val) = setter!(x, :phasedim, Int, val)

"""
    slicedim(x) -> Int

Which dimension slices where acquired at throughout MRI acquisition.
"""
slicedim(x) = getter(x, :slicedim, Int, i -> 1)
slicedim!(x, val) = setter!(x, :slicedim, Int, val)

"""
    slice_start(x) -> Int

Which slice corresponds to the first slice acquired during MRI acquisition
(i.e. not padded slices). Defaults to `1`.
"""
slice_start(x) = getter(x, :slice_start, Int, i -> 1)
slice_start!(x, val) = setter!(x, :slice_start, Int, val)

"""
    slice_end(x) -> Int

Which slice corresponds to the last slice acquired during MRI acquisition
(i.e. not padded slices).
"""
slice_end(x) = getter(x, :slice_end, Int, i -> 1)
slice_end!(x, val) = setter!(x, :slice_end, Int, val)

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
spatial_units(x) = unit.(eltype.(spatial_indices(x)))

"""
    start_time(x) -> F64Sec

Returns start time in seconds in relation to the start of acquisition of the first
data sample in the corresponding neural dataset (negative values are allowed).
"""
start_time(x) = first(timeaxis(x))

"""
    time_units(img)

Returns the units (i.e. Unitful.unit) the time axis is measured in. If not available
`nothing` is returned.
"""
time_units(x) = unit(eltype(timeaxis(x)))
