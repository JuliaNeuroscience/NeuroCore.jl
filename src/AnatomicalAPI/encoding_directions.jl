
"""
    EncodingDirection

Possible values: `ipos`, `jpos`, `kpos`, `ineg, `jneg`, `kneg` (the axis of the NIfTI data along which
slices were acquired, and the direction in which SliceTiming is defined with
respect to). `ipos`, `jpos`, `kpos` identifiers correspond to the first, second and third axis
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
    if  (e === Symbol("i")) | (e === Symbol("ipos"))
        return ipos
    elseif (e === Symbol("i-")) | (e === Symbol("ineg"))
        return ineg
    elseif  (e === Symbol("j")) | (e === Symbol("jpos"))
        return jpos
    elseif (e === Symbol("j-")) | (e === Symbol("jneg"))
        return jneg
    elseif  (e === Symbol("k")) | (e === Symbol("kpos"))
        return kpos
    elseif (e === Symbol("k-")) | (e === Symbol("kneg"))
        return kneg
    else
        error("$e is not a supported encoding direction.")
    end
end
Base.String(e::EncodingDirection) = String(Symbol(e))

@inline function encoding_name(x::Int)
    if x === 1
        return :left
    elseif x === -1
        return :right
    elseif x === 2
        return :posterior
    elseif x === -2
        return :anterior
    elseif x === 3
        return :inferior
    elseif x === -3
        return :superior
    else
        error("$x does not map to a dimension name.")
    end
end

encoding_name(x) = encoding_name(Int(x))

