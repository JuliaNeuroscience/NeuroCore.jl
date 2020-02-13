# FIXME/TODO: These all depend on axes having names and spatial properties. Unfortunately,
# AxisArrays is being phased out and has yet to be replaced by anything. So this is all
# pretty brittle code
# There's also some type piracy to get things working here.

"""
    NeuroArray(array; axes...[, metadata])

## Examples
```jldoctest
julia> using NeuroCore

julia> x = NeuroArray(rand(2,3,4,10);
               left = 1:2,
               anterior = 1:3,
               superior=1:4,
               time = range(1, stop=10, length=10));

julia> dimnames(x)
(:left, :anterior, :superior, :time)

julia> is_radiologic(x)
true

julia> is_neurologic(x)
false

julia> dim(x, :left) == sagittaldim(x) == 1
true

julia> coronaldim(x)
2

julia> axialdim(x)
3

julia> indices_sagittal(x)
1:2

julia> indices_coronal(x)
1:3

julia> indices_axial(x)
1:4

julia> sampling_rate(x)
1.0

julia> duration(x)
9.0

julia> stop_time(x)
10.0
```
"""
const NeuroArray{T,N,A<:AbstractArray{T,N},M<:AbstractMetadata,Ax} = ImageMeta{T,N,AxisArray{T,N,A,Ax},M}

function NeuroArray(a::AbstractArray; metadata::AbstractMetadata=Metadata(), axs...)
    return NeuroArray(a, axs.data, Metadata(metadata))
end

function NeuroArray(a::AbstractArray, axs, m::AbstractMetadata)
    return ImageMeta(AxisArray(a, nt2axis(axs)), m)
end

nt2axis(axs::NamedTuple{name}) where {name} = (Axis{first(name)}(first(axs)), nt2axis(Base.tail(axs))...)
nt2axis(axs::NamedTuple{(),Tuple{}}) = ()
nt2axis(axs::Tuple{Vararg{<:Axis}}) = axs

_values(x::AbstractArray) = x
_values(x::Axis) = x.val

NamedDims.dimnames(::Type{<:AxisArray{T,N,A,Ax}}) where {T,N,A,Ax} = axisnames(Ax)
NamedDims.dimnames(::Type{<:ImageMeta{T,N,A}}) where {T,N,A} = dimnames(A)
NamedDims.dimnames(::Type{T}) where {T<:Axis} = axisnames(T)

NamedDims.dim(x::AbstractArray, name) = dim(dimnames(x), name)

function finddim(f::Function, x)
    for (i,n) in enumerate(dimnames(x))
        f(n) && return i
    end
    return nothing
end

indices(x::AxisArray) = getfield(x, :axes)
indices(x) = keys.(axes(x))

#indices(x, d::Symbol) = _indices(indices(x, dim(dimnames(x), d)))
#indices(x, d::Int) = _indices(indices(x)[d])
indices(x::ImageMeta, i::Int) = indices(arraydata(x), i)
indices(x::AxisArray, i::Int) = _values(x.axes[i])

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
        $namedim(x) = finddim($is_name, x)

        @doc $indices_name_doc
        $indices_name(x) = indices(x, $namedim(x))
    end
end

spatial_eltype(x) = eltype.(indices_spatial(x))

"""
    spatial_units(x)

Returns the units (i.e. Unitful.unit) that each spatial axis is measured in. If not
available `nothing` is returned for each spatial axis.
"""
spatial_units(x) = unit.(spatial_eltype(x))

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
    onset(x)
    onset!(x, val)

First time point along the time axis.
"""
@defprop Onset{:onset}::F64Second begin
    @getproperty x::AbstractArray -> first(_values(timeaxis(x)))
end


"""
    sampling_rate(x)
    sampling_rate!(x, val)

Number of samples per second.
"""
@defprop SamplingRate{:sampling_rate}::(x -> sampling_rate_type(x)) begin
    @getproperty x::AbstractArray -> 1/step(_values(timeaxis(x)))
end

sampling_rate_type(x) = typeof(1.0 / s)

"Last time point along the time axis."
@defprop StopTime{:stop_time}::F64Second begin
    @getproperty x::AbstractArray -> last(_values(timeaxis(x)))
end

"Duration of the event along the time axis."
@defprop Duration{:duration}::F64Second begin
    @getproperty x::AbstractArray -> stop_time(x) - onset(x)
end

"""
    time_continuity(x)
    time_continuity!(x, val)

Defines whether the recording is "continuous", "discontinuous" or "epoched";
this latter limited to time windows about events of interest (e.g., stimulus
presentations, subject responses etc.)
"""
@defprop TimeContinuity{:time_continuity}

"""
    spatial_offset(x)
    spatial_offset!(x, val)

The offset of each dimension (i.e., where each spatial axis starts).
"""
@defprop SpatialOffset{:spatial_offset}::(x -> spatial_eltype(x)) begin
    @getproperty x::AbstractArray -> first.(indices_spatial(x))
end

