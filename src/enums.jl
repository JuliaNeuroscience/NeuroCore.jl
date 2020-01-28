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
