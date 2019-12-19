
"""
    BIDSMetadata

Metadata for describing a BIDS dataset.
"""
struct BIDSMetadata
    "The name of the dataset"
    name::String = ""

    "The version of the BIDS standard that was used."
    bids_version::String = "1.0"

    "Returns the license that a given dataset is distributed under? The use of
    license name abbreviations is suggested for specifying a license
    (e.g., PD, PDDL, CCO)."
    license::String = ""

    "list of individuals who contributed to the creation/curation of the dataset."
    authors::Vector{String} = String[]

    "Returns the text acknowledging contributions of individuals or institutions
    beyond those listed in Authors or Funding."
    acknowledgedgements::String=""

    "Instructions how researchers using this dataset should acknowledge the original
    authors. This field can also be used to define a publication that should be cited in
    publications that use the dataset."
    how_to_acknowledge::String = ""

    "List of sources of funding (grant numbers)"
    funding::Vector{String} = String[]

    "List of references to publication that contain information on the dataset, or links."
    references::Vector{String} = String[]

    "Returns the Document Object Identifier of the dataset (not the corresponding paper)."
    doi::String = ""
end
