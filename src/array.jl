
const NeuroMetaArray{T,N,A<:AbstractArray{T,N},D} = ImageMeta{T,N,A,<:NeuroMetadata{D}}

NeuroMetaArray(x::AbstractArray) = ImageMeta(x, NeuroMetadata())
NeuroMetaArray(x::AbstractArray, p::NeuroMetadata) = NeuroMetaArray(x, p)
NeuroMetaArray(x::AbstractArray, p::AbstractDict) = NeuroMetaArray(x, NeuroMetadata(p))
NeuroMetaArray(x; kwargs...) = NeuroMetaArray(x, NeuroMetadata(; kwargs...))

# TODO: add to ImageMetadata
ImageCore.HasProperties(::Type{T}) where {T<:ImageMeta} = HasProperties{true}()

@inline Base.getproperty(x::NeuroMetaArray, s::Symbol) = neuroproperty(x, s)
@inline Base.setproperty!(x::NeuroMetaArray, s::Symbol, val) = neuroproperty!(x, s, val)

