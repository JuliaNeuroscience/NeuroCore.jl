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

function dimname2number(x::Symbol)
    if is_left(x)
        return 1
    elseif is_right(x)
        return -1
    elseif is_posterior(x)
        return 2
    elseif is_anterior(x)
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
        return :posterior
    elseif n === -2
        return :anterior
    elseif n === 3
        return :inferior
    elseif n === -3
        return :superior
    else
        error("$n does not map to a dimension name.")
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
