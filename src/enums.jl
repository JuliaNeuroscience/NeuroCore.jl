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

"""
    ContrastIngrediant

An enumerable type with the following possible values:
* `IODINE`
* `GADOLINIUM`
* `CARBON`
* `DIOXIDE`
* `BARIUM`
* `XENON`
* `UnkownContrast`
"""
@enum ContrastIngrediant begin
    IODINE
    GADOLINIUM
    CARBON
    DIOXIDE
    BARIUM
    XENON
    UnkownContrast
end
ContrastIngrediant(i::AbstractString) = ContrastIngrediant(Symbol(i))
function ContrastIngrediant(i::Symbol)
    if i === :IODINE
        return IODINE
    elseif i === :GADOLINIUM
        return GADOLINIUM
    elseif i === :CARBON
        return CARBON
    elseif i === :DIOXIDE
        return DIOXIDE
    elseif i === :BARIUM
        return BARIUM
    elseif i === :XENON
        return XENON
    else
        return UnkownContrast
    end
end
Base.String(i::ContrastIngrediant) = String(Symbol(i))
