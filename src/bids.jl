"""
    fiducial_description(x) -> String

A freeform text field documenting the anatomical landmarks that were used and how
the head localization coils were placed relative to these. This field can describe,
for instance, whether the true anatomical locations of the left and right pre-auricular
points were used and digitized, or rather whether they were defined as the intersection
between the tragus and the helix (the entry of the ear canal), or any other anatomical
description of selected points in the vicinity of the ears.

Corresponds to BIDS "FiducialDescription".
"""
fiducial_description(x) = getter(x, :fiducial_description, String, i -> "")
fiducial_description!(x, val) = setter!(x, :fiducial_description, String, val)
"""
    intended_for(x) -> Vector{String}

Path or list of path relative to the subject subfolder pointing to the structural
MRI, possibly of different types if a list is specified, to be used with the MEG
recording. The path(s) need(s) to use forward slashes instead of backward slashes
(e.g. ses-/anat/sub-01_T1w.nii.gz).

Corresponds to BIDS "IntendedFor".
"""
intended_for(x) = getter(x, :intended_for, Vector{String}, i -> String[])
intended_for!(x, val) = setter!(x, :intended_for, Vector{String}, val)

"""
    power_line_frequency(x) -> F64Hz

Frequency (in Hz) of the power grid at the geographical location of the EEG
instrument (i.e., 50 or 60).

Corresponds to BIDS "PowerLineFrequency".
"""
power_line_frequency(x) = getter(x, :power_line_frequency, F64Hz, i -> 1.0u"Hz")
power_line_frequency!(x, val) = setter!(x, :power_line_frequency, F64Hz, val)

# TODO: should this return an enumerable
"""
    recording_type(x) -> String


Corresponds to BIDS "RecordingType".
"""
recording_type(x) = getter(x, :recording_type, String, i -> "")
recording_type!(x, val) = setter!(x, :recording_type, String, val)

