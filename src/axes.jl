# FIXME/TODO: These all depend on axes having names and spatial properties. Unfortunately,
# AxisArrays is being phased out and has yet to be replaced by anything. So this is all
# pretty brittle code
# There's also some type piracy to get things working here.

const AbstractAxis{name,T} = Union{NamedTuple{name,Tuple{T}},Axis{name,T}}

_values(x::NamedTuple) = first(x)
_values(x::Axis) = x.val

NamedDims.dimnames(::Type{T}) where {T<:AxisArray} = axisnames(T)
NamedDims.dimnames(::Type{T}) where {T<:Axis} = axisnames(T)

NamedDims.dim(x::AbstractArray, name) = dim(dimnames(x), name)

Base.axes(x::AxisArray, name::Symbol) = AxisArrays.axes(x, dim(x, name))

has_dimname(x, name) = Base.sym_in(name, dimnames(x))

indices_sagittal(x) = axes(x, :sagittal)

indices_coronal(x) = axes(x, :coronal)

indices_axial(x) = axes(x, :axial)

indices_channel(x) = axes(x, :axial)

"""
    time_units(x)

Returns the units (i.e. Unitful.unit) the time axis is measured in. If not available
`nothing` is returned.
"""
time_units(x) = unit(time_type(x))

"""
First time point along the time axis.
"""
@defprop Onset{:onset}=x -> first(_values(timeaxis(x)))

"""
Number of samples per second.
"""
@defprop SamplingRate{:sampling_rate}::(x -> time_type(x))=x -> 1/step(_values(timeaxis(x)))

"""
Last time point along the time axis.
"""
@defprop StopTime{:stop_time}::(x -> time_type(x))=x -> last(_values(timeaxis(x)))

""""
Duration of the event along the time axis.
"""
@defprop Duration{:duration}::(x -> time_type(x))=(x -> stop_time(x) - onset(x))

"""
Defines whether the recording is "continuous", "discontinuous" or "epoched";
this latter limited to time windows about events of interest (e.g., stimulus
presentations, subject responses etc.)
"""
@defprop TimeContinuity{:time_continuity}

### Spatial traits
spatial_eltype(x) = eltype.(indices_spatial(x))

"""
Provides the offset of each dimension (i.e., where each spatial axis starts).
"""
@defprop SpatialOffset{:spatial_offset}::(x -> spatial_eltype(x))=x -> first.(coords_indices(x))

"""
    spatial_units(x)

Returns the units (i.e. Unitful.unit) that each spatial axis is measured in. If not
available `nothing` is returned for each spatial axis.
"""
spatial_units(x) = unit.(spatial_eltype(x))
