
abstract type AbstractMetadata{D<:AbstractDict{Symbol,Any}} <: AbstractDict{Symbol,Any} end

Base.haskey(m::AbstractMetadata, k) = haskey(properties(m), k)

Base.empty!(m::AbstractMetadata) = empty!(properties(m))

Base.get(m::AbstractMetadata, k, default) = get(properties(m), k, default)

Base.get!(m::AbstractMetadata, k, default) = get!(properties(m), k, default)

Base.in(k, m::AbstractMetadata) = in(k, propname(m))

Base.getkey(m::AbstractMetadata, k, default) = getkey(properties(m), k, default)

Base.pop!(m::AbstractMetadata, k) = pop!(properties(m), k)

Base.pop!(m::AbstractMetadata, k, default) = pop!(properties(m), k, default)

Base.isempty(m::AbstractMetadata) = isempty(properties(m))

Base.length(m::AbstractMetadata) = length(properties(m))

Base.iterate(m::AbstractMetadata) = iterate(properties(m))

Base.iterate(m::AbstractMetadata, state) = iterate(properties(m), state)

Base.delete!(m::AbstractMetadata, k) = delete!(properties(m), k)

@inline Base.getindex(x::AbstractMetadata, s::Symbol) = getindex(properties(x), s)

@inline function Base.setindex!(x::AbstractMetadata, val, s::Symbol)
    return setindex!(properties(x), val, s)
end

function ImageMetadata.properties(m::AbstractMetadata)
    error("All subtypes of AbstractMetadata must implement a properties method.")
end

"""
    NeuroMetadata

Dictionary structure for storing neuroscience related metadata.
"""
struct NeuroMetadata{D} <: AbstractMetadata{D}
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

Base.filter!(pred, m::NeuroMetadata) = filter!(pred, properties(m))

@inline Base.getproperty(x::NeuroMetadata, s::Symbol) = neuroproperty(x, s)

@inline Base.setproperty!(x::NeuroMetadata, s::Symbol, val) = neuroproperty!(x, s, val)

function Base.propertynames(x::NeuroMetadata)
    return isempty(x) ? Tuple(PROPERTIES) : Tuple(merge(PROPERTIES, [keys(x)...]))
end
