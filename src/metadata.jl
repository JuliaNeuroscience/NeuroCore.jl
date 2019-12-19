struct NeuroMetadata{D<:AbstractDict{Symbol,Any}} <: AbstractDict{Symbol,Any}
    _properties::D
end

function NeuroMetadata(; kwargs...)
    out = Dict{Symbol,Any}()
    for (k,v) in kwargs
        out[k] = v
    end
    return NeuroMetadata(out)
end

ImageMetadata.properties(nm::NeuroMetadata) = getfield(nm, :_properties)

Base.copy(nm::NeuroMetadata) = NeuroMetadata(copy(properties(nm)))

Base.setindex!(m::NeuroMetadata, X, k::Symbol) = setindex!(properties(m), X, k)

Base.haskey(m::NeuroMetadata, k) = haskey(properties(m), k)

Base.empty!(m::NeuroMetadata) = empty!(properties(m))

Base.get(m::NeuroMetadata, k, default) = get(properties(m), k, default)

Base.get!(m::NeuroMetadata, k, default) = get!(properties(m), k, default)

Base.in(m::NeuroMetadata, k) = in(propname(m), k)

Base.getkey(m::NeuroMetadata, k, default) = getkey(properties(m), k, default)

Base.pop!(m::NeuroMetadata, k) = pop!(properties(m), k)

Base.pop!(m::NeuroMetadata, k, default) = pop!(properties(m), k, default)

Base.delete!(m::NeuroMetadata, k) = delete!(properties(m), k)

Base.isempty(m::NeuroMetadata) = isempty(properties(m))

Base.length(m::NeuroMetadata) = length(properties(m))

Base.iterate(m::NeuroMetadata) = iterate(properties(m))

Base.iterate(m::NeuroMetadata, state) = iterate(properties(m), state)

Base.filter!(pred, m::NeuroMetadata) = filter!(pred, properties(m))

@inline Base.getproperty(x::NeuroMetadata, s::Symbol) = neuroproperty(x, s)
@inline Base.getindex(x::NeuroMetadata, s::Symbol) = neuroproperty(x, s)

function Base.propertynames(x::NeuroMetadata)
    return isempty(x) ? Tuple(PROPERTIES) : Tuple(merge(PROPERTIES, [keys(x)...]))
end
