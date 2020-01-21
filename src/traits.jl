"""
    is_anatomical(::T) -> Bool

Returns `true` if `T` represents anatomical data.
"""
is_anatomical(::T) where {T} = is_anatomical(T)
is_anatomical(::Type{T}) where {T} = false

"""
    is_electrophysiology(::T) -> Bool

Returns `true` if `T` represents electrophysiology data.
"""
is_electrophysiology(::T) where {T} = is_electrophysiology(T)
is_electrophysiology(::Type{T}) where {T} = has_channel_axis(T) & has_time_axis(T)

"""
    is_functional(::T) -> Bool

Returns `true` if `T` represents functional data.
"""
is_functional(::T) where {T} = is_functional(T)
is_functional(::Type{T}) where {T} = false

"The manufacturer of the equipment that produced the composite instances."
@defprop Manufacturer{:manufacturer}::String

"The manufacturer's model name of the equipment that produced the composite instances."
@defprop ManufacturerModelName{:manufacturer_model_name}::String

"""
The serial number of the equipment that produced the composite instances. A
pseudonym can also be used to prevent the equipment from being identifiable,
so long as each pseudonym is unique within the dataset.
"""
@defprop DeviceSerialNumber{:device_serial_number}::String

"The manufacturer’s designation of software version of the equipment that produced the composite instances."
@defprop SoftwareVersions{:software_versions}::String

"Name of the institution in charge of the equipment that produced the composite instances."
@defprop InstitutionName{:institution_name}::String

"The department in the institution in charge of the equipment that produced the composite instances."
@defprop InstitutionalDepartmentName{:institutional_department_name}::String

"The address of the institution in charge of the equipment that produced the composite instances."
@defprop InstitutionAddress{:institution_address}::String

"Institution defined name of the machine that produced the composite instances."
@defprop StationName{:station_name}::String

"""
Freeform description of the observed subject artefact and its possible cause (e.g.,
"door open", "nurse walked into room at 2 min", "seizure at 10 min"). If this
field is left empty, it will be interpreted as absence of artifacts.
"""
@defprop ArtefactDescription{:artefact_description}::String

"""
`Path or list of path relative to the subject subfolder pointing to the structural
MRI, possibly of different types if a list is specified, to be used with the MEG
recording. The path(s) need(s) to use forward slashes instead of backward slashes
(e.g. ses-/anat/sub-01_T1w.nii.gz).
"""
@defprop IntendedFor{:intended_for}::Vector{String}

"""
Text of the instructions given to participants before the scan. This is especially
important in context of resting state fMRI and distinguishing between eyes open and
eyes closed paradigms.
"""
@defprop Instructions{:instructions}::String

"URL of the corresponding [Cognitive Atlas Task](https://www.cognitiveatlas.org/) term."
@defprop CogAtlasID{:cog_atlas_id}::String

"URL of the corresponding [CogPO](http://www.cogpo.org/) term."
@defprop CogPOID{:cog_poid}::String
