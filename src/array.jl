
const NeuroMetaArray{T,N,A,D} = ImageMeta{T,N,A,NeuroMetadata{D}}

NeuroMetaArray(x::AbstractArray) = ImageMeta(x, NeuroMetadata())
NeuroMetaArray(x::AbstractArray, p::NeuroMetadata) = NeuroMetaArray(x, p)
NeuroMetaArray(x::AbstractArray, p::AbstractDict) = NeuroMetaArray(x, NeuroMetadata(p))
NeuroMetaArray(x; kwargs...) = NeuroMetaArray(x, NeuroMetadata(; kwargs...))

Base.getproperty(x::NeuroMetaArray, s::Symbol) = getproperty(properties(x), s)

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
    freqdim(x) -> Int

Which spatial dimension (1, 2, or 3) corresponds to phase acquisition. If not
applicable to scan type defaults to `0`.
"""
freqdim(x) = getter(x, :freqdim, Int, 0)
freqdim!(x, val) = setter!(x, :freqdim, Int, val)

"""
    slicedim(x) -> Int

Which dimension slices where acquired at throughout MRI acquisition.
"""
slicedim(x) = getter(x, :slicedim, Int, i -> 0)
slicedim!(x, val) = setter!(x, :slicedim, Int, val)

"""
    phasedim(x) -> Int

Which spatial dimension (1, 2, or 3) corresponds to phase acquisition.
"""
phasedim(x) = getter(x, :phasedim, Int, i -> 0)
phasedim!(x, val) = setter!(x, :phasedim, Int, val)

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
    time_units(img)

Returns the units (i.e. Unitful.unit) the time axis is measured in. If not available
`nothing` is returned.
"""
time_units(x) = unit(eltype(timeaxis(x)))

"""
    start_time(x) -> F64Sec

Returns start time in seconds in relation to the start of acquisition of the first
data sample in the corresponding neural dataset (negative values are allowed).
"""
start_time(x) = first(timeaxis(x))

"""
    calmax(x)

Specifies maximum element for display puproses. Defaults to the maximum of `x`.
"""
calmax(x::Any) = getter(x, :calmax, i -> _caltype(x), i -> _calmax(i))
calmax!(x::Any, val::Any) = setter!(x, :calmax, val, i -> _caltype(i))

"""
    calmin(x)

Specifies minimum element for display puproses. Defaults to the minimum of `x`.
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
