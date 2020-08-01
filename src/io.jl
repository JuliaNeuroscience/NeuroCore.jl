
@inline function read_type_swap(io, ::Type{T}) where {T<:Tuple}
    return ((read_type_swap(io, T_i) for T_i in T.parameters)...,)
end

@inline function read_type_noswap(io, ::Type{T}) where {T<:Tuple}
    return ((read_type_noswap(io, T_i) for T_i in T.parameters)...,)
end

read_type_noswap(io, ::Type{T}) where {T} = read(io, T)
read_type_swap(io, ::Type{T}) where {T} = bswap(read(io, T))


@inline function read_type(io, ::Type{T}, needswap::Bool) where {T}
    if needswap
        return read_type_swap(io, T)
    else
        return read_type_noswap(io, T)
    end
end

function swap_array(A, needswap::Bool)
    if needswap
        return mappedarray(ntoh, hton, A)
    else
        return A
    end
end

function read_array(
    io,
    ::Type{T},
    sz::Tuple{Vararg{<:Integer,N}},
    needswap::Bool,
    mmap::Bool=true,
    mode::AbstractString="r";
    grow::Bool=true,
    shared::Bool=true
) where {T,N}

    if mmap
        return swap_array(Mmap.mmap(io, Array{T,N}, sz, grow=grow, shared=shared), needswap)
    else
        return swap_array(read!(io, Array{T,N}(undef, sz)), needswap)
    end
end





#=

@inline function read_type_noswap(io, ::Type{T}) where {T<:Tuple}
    return ((read_type_noswap(io, T_i) for T_i in T.parameters)...,)
end
@inline read_type_noswap(io, ::Type{T}) where {T} = read(io, T)

@inline function read_type_swap(io, ::Type{T}) where {T<:Tuple}
    return ((read_type_swap(io, T_i) for T_i in T.parameters)...,)
end
@inline read_type_swap(io, ::Type{T}) where {T} = bswap(read(io, T))
=#



