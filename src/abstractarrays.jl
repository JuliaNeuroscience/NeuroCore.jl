
using AbstractIndices, ImageMetadata, ImageCore

const MetaIndicesArray{T,N,A,I} = IndicesArray{T,N,ImageMeta{T,N,A},I}

const NamedIndicesArray{L,T,N,A,I} = NamedDimsArray{L,T,N,IndicesArray{T,N,A,I}}

const ImageArray{L,T,N,A,I} = NamedIndicesArray{L,T,N,ImageMeta{T,N,A},I}

ImageCore.HasProperties(::Type{T}) where {T<:NamedDimsArray} = HasProperties(parent_type(T))

ImageCore.HasProperties(::Type{T}) where {T<:IndicesArray} = HasProperties(parent_type(T))


# ImageMetadata
ImageMetadata.properties(img::ImageArray) = properties(parent(img))
ImageMetadata.properties(img::MetaIndicesArray) = properties(parent(img))

function ImageMetadata.spatialproperties(img::ImageArray)
    return ImageMetadata.@get img "spatialproperties" ["spacedirections"]
end

Base.delete!(img::ImageArray, propname::AbstractString) = delete!(properties(img), propname)

Base.get(img::ImageArray, k::AbstractString, default) = get(properties(img), k, default)

Base.haskey(img::ImageArray, k::AbstractString) = haskey(properties(img), k)

is_color_axis(::NamedTuple{(:color,)}) = true

first_pair(x::NamedTuple{names}) where {names} = NamedTuple{(first(names),)}((first(x),))

"""
    is_color_axis(ni::Index) -> Bool

Determines whether a given axis refers to a color dimension.
"""
is_color_axis(::T) where {T} = is_color_axis(T)
is_color_axis(::Type{<:Index{:color}}) = true
is_color_axis(::Type{<:Index{name}}) where {name} = false

colordim(x) = find_axis(is_color_axis, x)

function ImageCore.spacedirections(img::ImageArray)
    return getter(img, "spacedirections", axes_type(img), spacedirections(namedaxes(img)))
end
