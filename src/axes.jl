# FIXME/TODO: These all depend on axes having names and spatial properties. Unfortunately,
# AxisArrays is being phased out and has yet to be replaced by anything. So this is all
# pretty brittle code
# There's also some type piracy to get things working here.

_values(x::NamedTuple) = first(x)
_values(x::Axis) = x.val

NamedDims.dimnames(::Type{T}) where {T<:AxisArray} = axisnames(T)
NamedDims.dimnames(::Type{T}) where {T<:Axis} = axisnames(T)

NamedDims.dim(x::AbstractArray, name) = dim(dimnames(x), name)

# TODO if changes to dimnames interface gets anymore complicated this should
# probably be generated with a macro
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

"`is_sagittal(x)`: Returns `true` if `x` represent the sagittal orientation."
is_sagittal(x::Symbol) = is_left(x) | is_right(x) | (x === :sagittal)

"`is_coronal(x)`: Returns `true` if `x` represent the coronal orientation."
is_coronal(x::Symbol) = is_anterior(x) | is_posterior(x) | (x === :coronal)

"`is_axial(x)`: Returns `true` if `x` represent the axial orientation."
is_axial(x::Symbol) = is_superior(x) | is_inferior(x) | (x === :axial)

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
        $indices_name(x) = indices(x, $is_name)
    end
end

"""
    is_radiologic(x) -> Bool

Test to see if `x` is in radiological orientation.
"""
is_radiologic(x) = is_radiologic(([dimnames(x, i) for i in coords_spatial(x)]...))
function is_radiologic(x::NTuple{3,Symbol})
    return is_left(first(x)) & is_anterior(x[2]) & is_superior(last(x))
end

"""
    is_neurologic(x) -> Bool

Test to see if `x` is in neurological orientation.
"""
is_neurologic(x) = is_neurologic(([dimnames(x, i) for i in coords_spatial(x)]...))
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
        error("$x is not a supported dimension.")
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
        error("$n does not map to a dimension name.")
    end
end
