"""
    dataset_name(x)

Returns the name of the dataset.
"""
dataset_name(x) = getter(x, "Name", String, x -> "")

"""
    dataset_name!(x, name)

Sets the name of the dataset.
"""
dataset_name!(x, val) = dataset_name!(x, "Name", String, val)

"""
    bids_version(x)

Returns the version of the BIDS standard that was used.
"""
bids_version(x) = getter(x, "BIDSVersion", String, x -> "1.0")

"""
    bids_version!(x, val)

Sets the version of the BIDS standard that was used.
"""
bids_version!(x, val) = setter!(x, "BIDSVersion", String, val)

"""
    license(x) -> String

Returns the license that a given dataset is distributed under? The use of
license name abbreviations is suggested for specifying a license
(e.g., PD, PDDL, CCO).
"""
license(x) = getter(x,  "License", String, x -> "")

"""
    license!(x, val)

Sets the license that a given dataset is distributed under? The use of
license name abbreviations is suggested for specifying a license
(e.g., PD, PDDL, CCO).
"""
license!(x, val) = setter!(x,  "License", String, val)

"""
    authors(x) -> Vector{String}

Returns list of individuals who contributed to the creation/curation of the dataset.
"""
authors(x) = getter(x, "Authors", Vector{String}, x -> String[])

"""
    authors!(x, val)

Sets list of individuals who contributed to the creation/curation of the dataset.
"""
authors!(x, val) = setter!(x, "Authors", Vector{String}, val)

"""
    acknowledgedgements(x) -> String

Returns the text acknowledging contributions of individuals or institutions
beyond those listed in Authors or Funding.
"""
acknowledgedgements(x) = getter(x, "Acknowledgements", String, x -> "")

"""
    acknowledgedgements!(x, val)

Sets the text acknowledging contributions of individuals or institutions beyond those
listed in Authors or Funding.
"""
acknowledgedgements!(x, val) = setter!(x, "Acknowledgements", String, val)

"""
    how_to_acknowledge(x) -> String

Return instructions how researchers using this dataset should acknowledge the original
authors. This field can also be used to define a publication that should be cited in
publications that use the dataset.
"""
how_to_acknowledge(x) = getter(x, "HowToAcknowledge", String, x -> "")

"""
    how_to_acknowledge!(x, val)

Sets instructions how researchers using this dataset should acknowledge the original
authors. This field can also be used to define a publication that should be cited in
publications that use the dataset.
"""
how_to_acknowledge!(x, val) = getter(x, "HowToAcknowledge", String, val)

"""
    funding(x) -> Vector{String}

Returns list of sources of funding (grant numbers)
"""
funding(x) = getter(x, "Funding", Vector{String}, x -> String[])

"""
    funding!(x, val)

Sets list of sources of funding (grant numbers)
"""
funding!(x, val) = setter!(x, "Funding", Vector{String}, val)

"""
    references(x) -> Vector{String}

List of references to publication that contain information on the dataset, or links.
"""
references(x) = getter(x, "ReferencesAndLinks", Vector{String}, x -> String[])

"""
    references!(x, val)

Set list of references to publication that contain information on the dataset, or links.
"""
references!(x, val) = getter(x, "ReferencesAndLinks", Vector{String}, val)

"""
    doi(x) -> String

Returns the Document Object Identifier of the dataset (not the corresponding paper).
"""
doi(x) = getter(x, "DatasetDOI", String, x -> "")

"""
    doi!(x, val)

Sets the Document Object Identifier of the dataset (not the corresponding paper).
"""
doi!(x, val) = getter(x, "DatasetDOI", String, val)


"""
    stream_offset(x) -> Int

Returns the IO stream offset to data given an type instance. Defaults to 0.
"""
stream_offset(x) = getter(x, "stream_offset", Int, 1)

"""
    stream_offset!(x, val)

Set the the `data_offset` property.
"""
stream_offset!(x, val) = setter!(x, "stream_offset", Int, val)

"""

    auxfiles(x) -> Vector{String}

Returns string for auxiliary file associated with the image.
"""
auxfiles(x) = getter(x, "auxfiles", Vector{String}, x -> [""])

"""
    auxfiles!(x, val)

Sets the `auxfiles` property. `val` should be a `String` or `Vector{String}`.
"""
auxfiles!(x, val) = setter!(x, "auxfiles", Vector{String}, val)

"""
    srcfile(x) -> String

Retrieves the file name that the image comes from.
"""
srcfile(x) = getter(x, "srcfile", String, x -> "")

"""
    srcfile!(x, f::String)

Change `srcfile` property.
"""
srcfile!(x, val) = setter!(x, "srcfile", String, val)

"""
    description(x) -> String

Retrieves description field that may say whatever you like.
"""
description(x) = getter(x, "description", String, x -> "")

"""
    description!(x, descrip::String)

Change description defined in an properties type.
"""
description!(x, val) = setter!(x, "description", String, val)

"""
    magic_bytes(x) -> Vector{UInt8}

Retrieves the magicbytes associated with the file that produced an image
instance. Defaults to `[0x00]` if not found.
"""
magic_bytes(x) = getter(x, "magicbytes", Vector{UInt8}, x -> UInt8[])

"""
    magic_bytes(x, val)

Sets the `magic_bytes` property.
"""
magic_bytes!(x, val) = setter!(x, "magic_bytes", Vector{UInt8}, val)

###
_caltype(x::AbstractArray{T}) where {T} = T
_caltype(x::Any) = Float64

"""
    calmax(x)

Specifies maximum element for display puproses. Defaults to the maximum of `x`.
"""
calmax(x::Any) = getter(x, "calmax", i -> _caltype(x), i -> _calmax(i))
_calmax(x::AbstractArray) = maximum(x)
_calmax(x::Any) = one(Float64)

"""
    calmax!(x, val)

Change calmax defined in an `ImageProperties` type.
"""
calmax!(x::Any, val::Any) = setter!(x, "calmax", val, i -> _caltype(i))

"""

    calmin(x)

Specifies minimum element for display puproses. Defaults to the minimum of `x`.
"""
calmin(x) = getter(x, "calmin", i -> _caltype(i), i -> _calmin(i))
_calmin(x::AbstractArray) = minimum(x)
_calmin(x::Any) = one(Float64)

"""
    calmin!(x, val)

Set the calmin property.
"""
calmin!(x, val) = setter!(x, "calmin", val, i -> _caltype(i))

