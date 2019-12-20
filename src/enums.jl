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
    i = 1
    in = -1
    j = 2
    jn = -2
    k = 3
    kn = -3
end

"""
    ContrastIngrediant

An enumerable type with the following possible values:
* `IODINE`
* `GADOLINIUM`
* `CARBON`
* `DIOXIDE`
* `BARIUM`
* `XENON`
"""
@enum ContrastIngrediant begin
    IODINE
    GADOLINIUM
    CARBON
    DIOXIDE
    BARIUM
    XENON
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
        error("$i is not a supported contrast ingredient. See ContrastIngrediant
              for supported ingrediants.")
    end
end
Base.String(i::ContrastIngrediant) = String(Symbol(i))
