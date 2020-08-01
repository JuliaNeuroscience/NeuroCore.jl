
"""
    PointNode(coordinate, properties)

## Examples
```jldoctest
julia> using NeuroCore

julia> PointNode((1,2))
```
"""
struct PointNode{Dim,T,C<:AbstractPoint{Dim,T},P} <: AbstractPoint{Dim,T}
    coordinates::C
    properties::P

    PointNode{Dim,T,C,P}(coord::C, props::P) where {Dim,T,C,P} = new{Dim,T,C,P}(coord, props)
end

function PointNode{Dim,T,C}(coord::C, props::P=nothing) where {Dim,T,C<:AbstractPoint{Dim,T},P}
    return PointNode{Dim,T,C,P}(coord, props)
end

function PointNode{Dim,T}(coord::AbstractPoint{Dim,T}, props=nothing) where {Dim,T}
    return PointNode{Dim,T,typeof(coord)}(coord, props)
end

function PointNode{Dim}(coord::AbstractPoint{Dim,T}, props=nothing) where {Dim,T}
    return PointNode{Dim,T}(coord, props)
end

function PointNode(coord::AbstractPoint{Dim}, prop=nothing) where {Dim}
    return PointNode{Dim}(coord, prop)
end

PointNode(coord::Tuple) = PointNode(Point(coord))

GeometryBasics.coordinates(n::PointNode) = getfield(n, :coordinates)

FieldProperties.properties(n::PointNode) = getfield(n, :properties)

#FieldProperties.@hasfieldprop PointNode

Base.@propagate_inbounds Base.getindex(n::PointNode, i::Int) = coordinates(n)[i]

Base.show(io::IO, n::PointNode) = print_node(io, n)

Base.show(io::IO, ::MIME"text/plain", n::PointNode) = print_node(io, n)

function print_node(io::IO, n::PointNode{Dim,T}) where {Dim,T}
    return print(io, "PointNode($(coordinates(n).data), $(properties(n)))")
end

"""
    PointNodeList{Dim,T,V,P}

"""
const PointNodeList{Dim,T<:PointNode{Dim},V<:AbstractVector{T},P} = MetadataArray{T,1,P,V}

#FieldProperties.@hasfieldprop PointNodeList

function PointNodeList{Dim,T}(v::AbstractVector{T}=T[], props=nothing) where {Dim,T<:PointNode{Dim}}
    return MetadataArray(v, props)
end

PointNodeList(v::AbstractVector{T}, props=nothing) where {T<:PointNode} = PointNodeList{length(T),T}(v, props)

"""
    MultiPointNodeList{T,V,P}
"""
const MultiPointNodeList{T<:PointNodeList,V<:AbstractVector{T},P} = MetadataArray{T,1,P,V}

#FieldProperties.@hasfieldprop PointNodeListVec
