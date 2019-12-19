


###
eset = """
    if s === :description
        return description!(x, val)
    """
for p in PROPERTIES
    eget = eget * """
        elseif s === :$(p)
            return $(p)!(x, val)
        """
end

eset = eset * """
    end
    """
@eval begin
    function neuroproperty!(x, s::Symbol, val)
        $eset
    end
end
