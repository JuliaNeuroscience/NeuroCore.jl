
const ArrayInitializer = Union{UndefInitializer, Missing, Nothing}

@inline FieldProperties.properties(A::AxisIndicesArray) = properties(parent(A))
@inline FieldProperties.properties(A::NamedDimsArray) = properties(parent(A))

"""
    AxesPropertyArray
"""
const AxesPropertyArray{T,N,A<:AbstractArray{T,N},Ax,P} = AxisIndicesArray{T,N,MetadataArray{T,N,P,A},Ax}
FieldProperties.@hasfieldprop AxesPropertyArray

function AxesPropertyArray(A::AbstractArray, inds::Tuple, proplist=nothing)
    return AxisIndicesArray(MetadataArray(A, proplist), inds)
end

"""
    NamedAxesPropertyArray
    NAPArray
"""
const NamedAxesPropertyArray{T,N,L,A<:AbstractArray{T,N},Ax,P} = NamedDimsArray{L,T,N,AxesPropertyArray{T,N,A,Ax,P}}
const NAPArray{T,N,L,A,Ax,P} = NamedAxesPropertyArray{T,N,L,A,Ax,P}
FieldProperties.@hasfieldprop NamedAxesPropertyArray


### NAPArray{T,N,L}(...)
function NAPArray{T,N,L}(A::AbstractArray, inds::Tuple, proplist=nothing) where {T,N,L}
    return NAPArray{T,N,L}(MetadataArray(A, proplist), inds)
end

function NAPArray{T,N,L}(A::MetadataArray, inds::Tuple) where {T,N,L}
    return NAPArray{T,N,L}(AxisIndicesArray(A, inds))
end

NAPArray{T,N,L}(A::AxesPropertyArray{T,N}) where {T,N,L} = NamedDimsArray{L}(A)

### NAPArray{T,N}(...)
NAPArray{T,N}(A::AbstractArray, inds::Tuple, proplist=nothing) where {T,N} = NAPArray{T,N,ntuple(_ -> :_, Val(N))}(A, inds, proplist)

function NAPArray{T,N}(A::AbstractArray, inds::NamedTuple{L}, proplist=nothing) where {T,N,L}
    return NAPArray{T,N,L}(A, values(inds), proplist)
end

NAPArray{T,N}(A::AbstractArray) where {T,N} = NAPArray{T,N,ntuple(_ -> :_, Val(N))}(A)


### NAPArray(...)
NAPArray(A::AbstractArray{T,N}, inds, proplist=nothing) where {T,N} = NAPArray{T,N}(A, inds, proplist)

function NAPArray(A::AbstractArray, args...; proplist=nothing, kwargs...)
    if isempty(args)
        if isempty(kwargs)
            return NAPArray(A, proplist)
        else
            return NAPArray(A, values(kwargs), proplist)
        end
    elseif isempty(kwargs)
        return NAPArray(x, args, proplist)
    else
        error("Indices can only be specified by keywords or additional arguments after the parent array, not both.")
    end
end

#=
function NAPArray{T,N,L}(init::ArrayInitializer, inds::Tuple, proplist=nothing) where {T,N,L}
    return NAPArray{T,N,L}(
        AxisIndices.AxisCore.init_array(StaticRanges._combine(typeof(axs)), T, init, inds),
        inds,
        proplist
    )
end

function NAPArray(A::MetadataArray, inds::NamedTuple{L}) where {L}
    return NamedDimsArray{L}(AxisIndicesArray(A, values(inds)))
end
NAPArray(A::MetadataArray, inds::Tuple) = NAPArray(AxisIndicesArray(A, inds))
NAPArray(A::MetadataArray{T,N}) where {T,N} = NamedDimsArray{ntuple(_ -> :_, Val(N))}(A)

function NAPArray(A::AbstractArray, inds::NamedTuple, proplist=nothing)
    return NAPArray(MetadataArray(A, proplist), inds)
end
function NAPArray(A::AbstractArray, inds::Tuple, proplist=nothing)
    return NAPArray(MetadataArray(A, proplist), inds)
end
NAPArray(A::AbstractArray, proplist=nothing) = NAPArray(MetadataArray(A, proplist))


NAPArray(A::AxesPropertyArray{T,N}) where {T,N} = NamedDimsArray{ntuple(_->:_, Val(N))}(A)
=#

