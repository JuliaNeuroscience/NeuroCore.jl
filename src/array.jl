
const NeuroMetaArray{T,N,A,D} = ImageMeta{T,N,A,NeuroMetadata{D}}

NeuroMetaArray(x::AbstractArray) = ImageMeta(x, NeuroMetadata())
NeuroMetaArray(x::AbstractArray, p::NeuroMetadata) = NeuroMetaArray(x, p)
NeuroMetaArray(x::AbstractArray, p::AbstractDict) = NeuroMetaArray(x, NeuroMetadata(p))
NeuroMetaArray(x; kwargs...) = NeuroMetaArray(x, NeuroMetadata(; kwargs...))

Base.getproperty(x::NeuroMetaArray, s::Symbol) = getproperty(properties(x), s)
