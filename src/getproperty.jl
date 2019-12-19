
eget = """
    if s === :description
        return description(x)
    """
for p in PROPERTIES
    global eget = eget * """
        elseif s === :$(p)
            return $(p)(x)
        """
end

eget = eget * """
    else
        return getindex(x, s)
    end
    """

@eval begin
    function neuroproperty(x, s::Symbol)
        Base.@_inline_meta
        $eget
    end
end

###
eset = """
    if s === :description
        return description!(x, val)
    """
for p in PROPERTIES
    global eset = eset * """
        elseif s === :$(p)
            return $(p)!(x, val)
        """
end

eset = eset * """
    else
        return setindex!(x, val, s)
    end
    """

@eval begin
    function neuroproperty!(x, s::Symbol, val)
        Base.@_inline_meta
        $eset
    end
end
