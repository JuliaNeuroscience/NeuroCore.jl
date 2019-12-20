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
