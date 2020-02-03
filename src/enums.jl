"""
    ContrastIngredient

An enumerable type with the following possible values:
* `IODINE`
* `GADOLINIUM`
* `CARBON`
* `DIOXIDE`
* `BARIUM`
* `XENON`
* `UnkownContrast`
"""
@enum ContrastIngredient begin
    IODINE
    GADOLINIUM
    CARBON
    DIOXIDE
    BARIUM
    XENON
    UnkownContrast
end
ContrastIngredient(i::AbstractString) = ContrastIngredient(Symbol(i))
function ContrastIngredient(i::Symbol)
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
Base.String(i::ContrastIngredient) = String(Symbol(i))
