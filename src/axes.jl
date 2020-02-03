# FIXME/TODO: These all depend on axes having names and spatial properties. Unfortunately,
# AxisArrays is being phased out and has yet to be replaced by anything. So this is all
# pretty brittle code
# There's also some type piracy to get things working here.


_values(x::AbstractArray) = x
_values(x::Axis) = x.val

NamedDims.dimnames(::Type{T}) where {T<:AxisArray} = axisnames(T)
NamedDims.dimnames(::Type{<:ImageMeta{T,N,A}}) where {T,N,A} = dimnames(A)
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

for name in (:sagittal,
             :axial,
             :coronal,
             :frequency,
             :channel)
    sym_name = QuoteNode(name)
    indices_name = Symbol(:indices_, name)
    is_name = Symbol(:is_, name)
    namedim = Symbol(name, :dim)

    namedim_doc = """
        $namedim(x) -> Int

    Return the dimension of the array used for $name time.
    """

    indices_name_doc = """
        $indices_name(x)

    Return the indices of the $name dimension.
    """
    @eval begin
        @doc $namedim_doc
        $namedim(x) = NamedDims.dim(dimnames(x), $sym_name)

        @doc $indices_name_doc
        $indices_name(x) = indices(x, NamedDims.dim(x, $sym_name))
    end
end

"""
    is_radiologic(x) -> Bool

Test to see if `x` is in radiological orientation.
"""
is_radiologic(x) = is_radiologic(spatialorder(x))
function is_radiologic(x::NTuple{3,Symbol})
    return is_left(first(x)) & is_anterior(x[2]) & is_superior(last(x))
end

"""
    is_neurologic(x) -> Bool

Test to see if `x` is in neurological orientation.
"""
is_neurologic(x) = is_neurologic(spatialorder(x))
function is_neurologic(x::NTuple{3,Symbol})
    return is_right(first(x)) & is_anterior(x[2]) & is_superior(last(x))
end

"""
    indices_unit(x, name)

Returns the unit (i.e. Unitful.unit) the name dimension is measured in. If units
are not defined `nothing` is returned.
"""
indices_unit(x) = unit(indices_eltype(x))

"First time point along the time axis."
@defprop Onset{:onset} begin
    @getproperty x::AbstractArray -> first(_values(timeaxis(x)))
end

sampling_rate_type(x) = typeof(1.0 / s)

"Number of samples per second."
@defprop SamplingRate{:sampling_rate}::(x -> sampling_rate_type(x)) begin
    @getproperty x::AbstractArray -> 1/step(_values(timeaxis(x)))
end


"Last time point along the time axis."
@defprop StopTime{:stop_time}::(x -> second_type(x)) begin
    @getproperty x::AbstractArray -> last(_values(timeaxis(x)))
end

"Duration of the event along the time axis."
@defprop Duration{:duration}::(x -> second_type(x)) begin
    @getproperty x::AbstractArray -> stop_time(x) - onset(x)
end

"""
Defines whether the recording is "continuous", "discontinuous" or "epoched";
this latter limited to time windows about events of interest (e.g., stimulus
presentations, subject responses etc.)
"""
@defprop TimeContinuity{:time_continuity}

### Spatial traits
spatial_eltype(x) = eltype.(indices_spatial(x))

"Provides the offset of each dimension (i.e., where each spatial axis starts)."
@defprop SpatialOffset{:spatial_offset}::(x -> spatial_eltype(x)) begin
    @getproperty x::AbstractArray -> first.(coords_indices(x))
end

"""
    spatial_units(x)

Returns the units (i.e. Unitful.unit) that each spatial axis is measured in. If not
available `nothing` is returned for each spatial axis.
"""
spatial_units(x) = unit.(spatial_eltype(x))
