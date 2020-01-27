# FIXME/TODO: These all depend on axes having names and spatial properties. Unfortunately,
# AxisArrays is being phased out and has yet to be replaced by anything. So this is all
# pretty brittle code
# There's also some type piracy to get things working here.

_values(x::NamedTuple) = first(x)
_values(x::Axis) = x.val

NamedDims.dimnames(::Type{T}) where {T<:AxisArray} = axisnames(T)
NamedDims.dimnames(::Type{T}) where {T<:Axis} = axisnames(T)

NamedDims.dim(x::AbstractArray, name) = dim(dimnames(x), name)

function finddim(f::Function, x)
    for (i,n) in enumerate(dimnames(x))
        f(i) && return true
    end
    return nothing
end

indices(x::AxisArray) = getfield(x, :axes)
indices(x) = keys.(axes(x))

indices(x, d::Symbol) = indices(x, dim(dimnames(x), d))
indices(x, d::Int) = indices(x)[d]
indices(x, f::Function) = indices(x, finddim(f, x))

"""
    indices_unit(x, name)

Returns the unit (i.e. Unitful.unit) the name dimension is measured in. If units
are not defined `nothing` is returned.
"""
indices_unit(x) = unit(indices_eltype(x))

"First time point along the time axis."
@defprop Onset{:onset}=x -> first(_values(timeaxis(x)))

"Number of samples per second."
@defprop SamplingRate{:sampling_rate}::(x -> time_type(x))=x -> 1/step(_values(timeaxis(x)))

"Last time point along the time axis."
@defprop StopTime{:stop_time}::(x -> time_type(x))=x -> last(_values(timeaxis(x)))

"Duration of the event along the time axis."
@defprop Duration{:duration}::(x -> time_type(x))=(x -> stop_time(x) - onset(x))

"""
Defines whether the recording is "continuous", "discontinuous" or "epoched";
this latter limited to time windows about events of interest (e.g., stimulus
presentations, subject responses etc.)
"""
@defprop TimeContinuity{:time_continuity}

### Spatial traits
spatial_eltype(x) = eltype.(indices_spatial(x))

"Provides the offset of each dimension (i.e., where each spatial axis starts)."
@defprop SpatialOffset{:spatial_offset}::(x -> spatial_eltype(x))=x -> first.(coords_indices(x))

"""
    spatial_units(x)

Returns the units (i.e. Unitful.unit) that each spatial axis is measured in. If not
available `nothing` is returned for each spatial axis.
"""
spatial_units(x) = unit.(spatial_eltype(x))

