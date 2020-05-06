
"""
    artefact_description(x)
    artefact_description!(x, val)

Freeform description of the observed subject artefact and its possible cause (e.g.,
"door open", "nurse walked into room at 2 min", "seizure at 10 min"). If this
field is left empty, it will be interpreted as absence of artifacts.
"""
@defprop ArtefactDescription{:artefact_description}::String

"""
    intended_for(x)
    intended_for!(x, val)

Path or list of path relative to the subject subfolder pointing to the structural
MRI, possibly of different types if a list is specified, to be used with the MEG
recording. The path(s) need(s) to use forward slashes instead of backward slashes
(e.g. ses-/anat/sub-01_T1w.nii.gz).
"""
@defprop IntendedFor{:intended_for}::Vector{String}

"""
    instructions(x)
    instructions!(x, val)

Text of the instructions given to participants before the scan. This is especially
important in context of resting state fMRI and distinguishing between eyes open and
eyes closed paradigms.
"""
@defprop Instructions{:instructions}::String

"""
    cog_atlas_id(x)
    cog_atlas_id!(x, val)

URL of the corresponding [Cognitive Atlas Task](https://www.cognitiveatlas.org/) term.
"""
@defprop CogAtlasID{:cog_atlas_id}::String

"""
    cog_poid(x)
    cog_poid!(x, val)

URL of the corresponding [CogPO](http://www.cogpo.org/) term.
"""
@defprop CogPOID{:cog_poid}::String

