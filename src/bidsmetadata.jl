"""
    BIDSMetadata

Metadata for describing a BIDS dataset.


* name : The name of the dataset
* bids_version : The version of the BIDS standard that was used.
* license: Returns the license that a given dataset is distributed under? The use of
  license name abbreviations is suggested for specifying a license (e.g., PD, PDDL, CCO).
* authors : list of individuals who contributed to the creation/curation of the dataset."
  acknowledgedgements: Returns the text acknowledging contributions of individuals or
  institutions beyond those listed in Authors or Funding.
* how_to_acknowledge: Instructions how researchers using this dataset should acknowledge
  the original authors. This field can also be used to define a publication that should be
  cited in publications that use the dataset.
* funding: List of sources of funding (grant numbers)
* references: List of references to publication that contain information on the dataset,
  or links.
* doi: Returns the Document Object Identifier of the dataset (not the corresponding paper)
"""
struct BIDSMetadata
    name::String
    bids_version::String
    license::String
    authors::Vector{String}
    acknowledgedgements::String
    how_to_acknowledge::String
    funding::Vector{String}
    references::Vector{String}
    doi::String
end
