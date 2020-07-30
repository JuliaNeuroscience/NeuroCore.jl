module SwapStreams

using MappedArrays

export
    BigEndian,
    LittleEndian,
    SwapStream

const LittleEndian = 0x01020304
const BigEndian = 0x04030201

"""

```jldoctest
julia> using NeuroCore

julia> s = NeuroCore.SwapStream(IOBuffer());

julia> write(s, [1:10...]);

julia> seek(s, 0);

julia> read!(s.io, Vector{Int}(undef, 10))
10-element Array{Int64,1}:
  72057594037927936
 144115188075855872
 216172782113783808
 288230376151711744
 360287970189639680
 432345564227567616
 504403158265495552
 576460752303423488
 648518346341351424
 720575940379279360

julia> seek(s, 0);

julia> read!(s, Vector{Int}(undef, 10))
10-element Array{Int64,1}:
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10

```
"""
struct SwapStream{S,IOType<:IO} <: IO
    io::IOType

    SwapStream{S}(io::IOType) where {S,IOType<:IO} = new{S,IOType}(io)

    SwapStream(io::IO) = SwapStream{true}(io)

    function SwapStream(file_endianness::UInt32, io::IOType) where {IOType}
        if file_endianness === ENDIAN_BOM
            return new{false,IOType}(io)
        else
            return new{true,IOType}(io)
        end
    end
end




Base.seek(s::SwapStream, n::Integer) = seek(s.io, n)
Base.position(s::SwapStream)  = position(s.io)
Base.skip(s::SwapStream, n::Integer) = skip(s.io, n)
Base.eof(s::SwapStream) = eof(s.io)
Base.isreadonly(s::SwapStream) = isreadonly(s.io)
Base.isreadable(s::SwapStream) = isreadable(s.io)
Base.iswritable(s::SwapStream) = iswritable(s.io)
Base.stat(s::SwapStream) = stat(s.io)
Base.close(s::SwapStream) = close(s.io)
Base.isopen(s::SwapStream) = isopen(s.io)
Base.ismarked(s::SwapStream) = ismarked(s.io)
Base.mark(s::SwapStream) = mark(s.io)
Base.unmark(s::SwapStream) = unmark(s.io)
Base.reset(s::SwapStream) = reset(s.io)
Base.seekend(s::SwapStream) = seekend(s.io)

Base.read(s::SwapStream, n::Int) = read(s.io, n)
Base.read(s::SwapStream{true}, x::Type{<:AbstractArray}) = bswap.(read(s.io, x))
Base.read(s::SwapStream{false}, x::Type{<:AbstractArray}) = read(s.io, x)
Base.read(s::SwapStream, x::Type{Int8}) = read(s.io, Int8)


Base.read!(s::SwapStream{true,<:IO}, a::Array{Int8,N}) where N = read!(s.io, a)
Base.read!(s::SwapStream{false,<:IO}, a::Array{Int8,N}) where N = read!(s.io, a)

Base.read!(s::SwapStream{true,<:IO}, a::Array{UInt8,N}) where N = read!(s.io, a)
Base.read!(s::SwapStream{false,<:IO}, a::Array{UInt8,N}) where N = read!(s.io, a)

Base.read!(s::SwapStream{false,IOType}, a::Array{T}) where {IOType<:IO,T} = read!(s.io, a)
Base.read!(s::SwapStream{true,IOType}, a::Array{T}) where {IOType<:IO,T} = bswap.(read!(s.io, a))

function Base.read(s::SwapStream{false},
              T::Union{Type{Int16},Type{UInt16},Type{Int32},Type{UInt32},Type{Int64},Type{UInt64},Type{Int128},Type{UInt128},Type{Float16},Type{Float32},Type{Float64}}
             )
    return Base.read!(s.io, Ref{T}(0))[]::T
end

function Base.read(s::SwapStream{true},
              T::Union{Type{Int16},Type{UInt16},Type{Int32},Type{UInt32},Type{Int64},Type{UInt64},Type{Int128},Type{UInt128},Type{Float16},Type{Float32},Type{Float64}}
             )
    return bswap(read!(s.io, Ref{T}(0))[]::T)
end

Base.read!(s::SwapStream{true}, ref::Base.RefValue{<:NTuple{N,T}}) where {N,T} = bswap.(read!(s.io, ref)[])
Base.read!(s::SwapStream{false}, ref::Base.RefValue{<:NTuple{N,T}}) where {N,T} = read!(s.io, ref)[]

Base.write(s::SwapStream{true,<:IO}, x::Array) = write(s.io, mappedarray(ntoh, hton, x))
Base.write(s::SwapStream{true,<:IO}, x::T) where T = write(s.io, bswap.(x))
Base.write(s::SwapStream{false,<:IO}, x::T) where T = write(s.io, x)

end
