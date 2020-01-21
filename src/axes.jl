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

"""
    sagittaldim(x) -> Int
"""
sagittaldim(x) = sagittaldim(dimnames(x))
function sagittaldim(dimnames::Tuple)::Int
    # 0-Allocations see: `@btime  (()->dim((:a, :b), :b))()`
    dimnum = NamedDims.dim_noerror(dimnames, :sagittal)
    if dimnum === 0
        dmnum = NamedDims.dim_noerror(dimnames, :left)
    end
    if dimnum === 0
        dmnum = NamedDims.dim_noerror(dimnames, :right)
    end
    if dimnames === 0
        throw(ArgumentError(
            "Specified name (:sagittal) does not match any dimension name ($dimnames)"
        ))
    end
    return dimnum
end
"""
    indices_sagittal(x)
"""
indices_sagittal(x) = axes(x, sagittaldim(x))

"""
    coronaldim(x) -> Int
"""
coronaldim(x) = coronaldim(dimnames(x))
function coronaldim(dimnames::Tuple)::Int
    # 0-Allocations see: `@btime  (()->dim((:a, :b), :b))()`
    dimnum = NamedDims.dim_noerror(dimnames, :coronal)
    if dimnum === 0
        dmnum = NamedDims.dim_noerror(dimnames, :anterior)
    end
    if dimnum === 0
        dmnum = NamedDims.dim_noerror(dimnames, :posterior)
    end
    if dimnames === 0
        throw(ArgumentError(
            "Specified name (:coronal) does not match any dimension name ($dimnames)"
        ))
    end
    return dimnum
end
"""
    indices_coronal(x)
"""
indices_coronal(x) = axes(x, coronaldim(x))


"""
    axialdim(x) -> Int
"""
axialdim(x) = axialdim(dimnames(x))
function axialdim(dimnames::Tuple)::Int
    # 0-Allocations see: `@btime  (()->dim((:a, :b), :b))()`
    dimnum = NamedDims.dim_noerror(dimnames, :axial)
    if dimnum === 0
        dmnum = NamedDims.dim_noerror(dimnames, :superior)
    end
    if dimnum === 0
        dmnum = NamedDims.dim_noerror(dimnames, :inferior)
    end
    if dimnames === 0
        throw(ArgumentError(
            "Specified name (:axial) does not match any dimension name ($dimnames)"
        ))
    end
    return dimnum
end
"""
    indices_axial(x)
"""
indices_axial(x) = axes(x, axialdim(x))

"""
    channeldim(x) -> Int
"""
channeldim(x) = dim(dimnames(x), :channel)

"""
    indices_channel(x)
"""
indices_channel(x) = axes(x, channeldim(x))

"""
    time_units(x)

Returns the units (i.e. Unitful.unit) the time axis is measured in. If not available
`nothing` is returned.
"""
time_units(x) = unit(time_type(x))

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


"""
    EncodingDirection

Possible values: `i`, `j`, `k`, `ineg, `jneg`, `kneg` (the axis of the NIfTI data along which
slices were acquired, and the direction in which SliceTiming is defined with
respect to). `i`, `j`, `k` identifiers correspond to the first, second and third axis
of the data in the NIfTI file. `*neg` indicates that the contents of
SliceTiming are defined in reverse order - that is, the first entry corresponds
to the slice with the largest index, and the final entry corresponds to slice
index zero. 
"""
@enum EncodingDirection begin
    ipos = 1
    ineg = -1
    jpos = 2
    jneg = -2
    kpos = 3
    kneg = -3
end
EncodingDirection(e::AbstractString) = EncodingDirection(Symbol(e))
function EncodingDirection(e::Symbol)
    if e === Symbol("i")
        return ipos
    elseif e === Symbol("i-")
        return ineg
    elseif e === Symbol("j")
        return jpos
    elseif e === Symbol("j-")
        return jneg
    elseif e === Symbol("k")
        return kpos
    elseif e === Symbol("k-")
        return kneg
    else
        error("$e is not a supported encoding direction.")
    end
end
Base.String(e::EncodingDirection) = String(Symbol(e))

"`is_left(x)`: Returns `true` if `x` represent the left position."
is_left(x::Symbol) = (x === :left) | (x === :L)

"`is_right(x)`: Returns `true` if `x` represent the right position."
is_right(x::Symbol) = (x === :right) | (x === :R)

"`is_anterior(x)`: Returns `true` if `x` represent the anterior position."
is_anterior(x::Symbol) = (x === :anterior) | (x === :A)

"`is_posterior(x)`: Returns `true` if `x` represent the posterior position."
is_posterior(x::Symbol) = (x === :posterior) | (x === :P)

"`is_inferior(x)`: Returns `true` if `x` represent the inferior position."
is_inferior(x::Symbol) = (x === :inferior) | (x === :I)

"`is_superior(x)`: Returns `true` if `x` represent the superior position."
is_superior(x::Symbol) = (x === :superior) | (x === :S)

function dimname2number(x::Symbol)
    if is_left(x)
        return 1
    elseif is_right(x)
        return -1
    elseif is_anterior(x)
        return 2
    elseif is_posterior(x)
        return -2
    elseif is_inferior(x)
        return 3
    elseif is_superior(x)
        return -3
    else
        error("")  # TODO dimname2number error
    end
end

function number2dimname(n::Int)
    if n === 1
        return :left
    elseif n === -1
        return :right
    elseif n === 2
        return :anterior
    elseif n === -2
        return :posterior
    elseif n === 3
        return :inferior
    elseif n === -3
        return :superior
    else
        error("")  # TODO number2dimname error
    end
end

"""
    is_radiologic(x) -> Bool

Test to see if `x` is in radiological orientation.
"""
function is_radiologic(x::NTuple{3,Symbol})
    return is_left(first(x)) & is_anterior(x[2]) & is_superior(last(x))
end

"""
    is_neurologic(x) -> Bool

Test to see if `x` is in neurological orientation.
"""
function is_neurologic(x::NTuple{3,Symbol})
    return is_right(first(x)) & is_anterior(x[2]) & is_superior(last(x))
end
