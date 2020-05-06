
"""
    PointNode
"""
struct PointNode{Dim, T, C<:AbstractPoint{Dim, T},P} <: AbstractPoint{Dim,T}
    coordinates::C
    properties::P
end

PointNode(coords::Tuple, props=nothing) = PointNode(Point(coords), props)

GeometryBasics.coordinates(p::PointNode) = getfield(p, :coordinates)

FieldProperties.properties(p::PointNode) = getfield(p, :properties)

@inline function Base.getproperty(p::PointNode, s::Symbol)
    return getproperty(getfield(p, :properties), s)
end

@inline function Base.setproperty!(p::PointNode, s::Symbol, val)
    return setproperty!(getfield(p, :properties), s, val)
end

Base.@propagate_inbounds function Base.getindex(p::PointNode, i::Int)
    return coordinates(p)[i]
end

function print_node(io::IO, p::PointNode{Dim,T,C,Nothing}) where {Dim,T,C}
    print(io, "PrintNode$(coordinates(p).data)")
end


"""
    NodeFiber
"""
const NodeFiber{T<:PointNode,V<:AbstractVector{T},P} = MetadataArray{T,1,P,V}

NodeFiber(v::AbstractVector{T}, props=nothing) where {T<:PointNode} = MetadataArray(v, props)

