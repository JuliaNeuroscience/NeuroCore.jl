"""
    stream_offset(x) -> Int

Returns the IO stream offset to data given an type instance. Defaults to 0.
"""
stream_offset(x) = getter(x, :stream_offset, Int, 1)
stream_offset!(x, val) = setter!(x, :stream_offset, Int, val)

"""
    auxfiles(x) -> Vector{String}

Returns string for auxiliary file associated with the image.
"""
auxfiles(x) = getter(x, :auxfiles, Vector{String}, i -> [""])
auxfiles!(x, val) = setter!(x, :auxfiles, Vector{String}, val)

"""
    srcfile(x) -> String

Retrieves the file name that the image comes from.
"""
srcfile(x) = getter(x, "srcfile", String, i -> "")
srcfile!(x, val) = setter!(x, "srcfile", String, val)

"""
    description(x) -> String

Retrieves description field that may say whatever you like.
"""
description(x) = getter(x, "description", String, i -> "")
description!(x, val) = setter!(x, "description", String, val)

"""
    magic_bytes(x) -> Vector{UInt8}

Retrieves the magicbytes associated with the file that produced an image
instance. Defaults to `[0x00]` if not found.
"""
magic_bytes(x) = getter(x, "magicbytes", Vector{UInt8}, i -> UInt8[])
magic_bytes!(x, val) = setter!(x, "magic_bytes", Vector{UInt8}, val)

"""
    calmax(x)

Specifies maximum element for display puproses. Defaults to the maximum of `x`.
"""
calmax(x::Any) = getter(x, "calmax", i -> _caltype(x), i -> _calmax(i))
calmax!(x::Any, val::Any) = setter!(x, "calmax", val, i -> _caltype(i))

"""
    calmin(x)

Specifies minimum element for display puproses. Defaults to the minimum of `x`.
"""
calmin(x) = getter(x, "calmin", i -> _caltype(i), i -> _calmin(i))
calmin!(x, val) = setter!(x, "calmin", val, i -> _caltype(i))

###
_caltype(x::AbstractArray{T}) where {T} = T
_caltype(x::Any) = Float64
_calmax(x::AbstractArray) = maximum(x)
_calmax(x::Any) = one(Float64)
_calmin(x::AbstractArray) = minimum(x)
_calmin(x::Any) = one(Float64)

