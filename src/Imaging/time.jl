"""
The echo time (TE) for the acquisition. This parameter is REQUIRED if corresponding
fieldmap data is present or the data comes from a multi echo sequence.
"""
@defprop EchoTime{:echo_time}::F64Sec

"""
Returns the inversion time (TI) for the acquisition, specified in seconds.
Inversion time is the time after the middle of inverting RF pulse to middle of
excitation pulse to detect the amount of longitudinal magnetization.
"""
@defprop InversionTime{:inversion_time}::F64Sec

"""
The time at which each slice was acquired within each volume (frame) of the
acquisition. Slice timing is not slice order -- rather, it is a list of times
(in JSON format) containing the time (in seconds) of each slice acquisition in
relation to the beginning of volume acquisition. The list goes through the
slices along the slice axis in the slice encoding dimension (see below). Note
that to ensure the proper interpretation of the `slice_timing` field, it is
important to check if the OPTIONAL `slice_encoding_direction` exists. In
particular, if `slice_encoding_direction` is negative, the entries in
`slice_timing` are defined in reverse order with respect to the slice axis
(i.e., the final entry in the `slice_timing` list is the time of acquisition of
slice 0). This parameter is REQUIRED for sparse sequences that do not have the
`delay_time` field set. In addition without this parameter slice time correction
will not be possible.
"""
@defprop SliceTiming{:slice_timing}::Vector{F64Sec}

"""
Possible values: `i`, `j`, `k`, `ineg, `jneg`, `kneg` (the axis of the NIfTI data along which
slices were acquired, and the direction in which slice_timing is defined with
respect to). `i`, `j`, `k` identifiers correspond to the first, second and third axis
of the data in the NIfTI file. `*neg` indicates that the contents of
slice_timing are defined in reverse order - that is, the first entry corresponds
to the slice with the largest index, and the final entry corresponds to slice
index zero. When present, the axis defined by `slice_encoding` needs to be
consistent with the ‘slicedim’ field in the NIfTI header. When absent, the
entries in slice_timing must be in the order of increasing slice index as defined
by the NIfTI header.
"""
@defprop SliceEncodingDirection{:slice_encoding_direction}::EncodingDirection

slice_encoding_direction(x::AbstractArray) = EncodingDirection(slicedim(x))
slice_encoding_direction!(x::AbstractArray, val) = slicedim!(x, val)

"""
Actual dwell time (in seconds) of the receiver per point in the readout
direction, including any oversampling. For Siemens, this corresponds to DICOM
field (0019,1018) (in ns). This value is necessary for the optional readout
distortion correction of anatomicals in the HCP Pipelines. It also usefully
provides a handle on the readout bandwidth, which isn’t captured in the other
metadata tags. Not to be confused with `effective_echo_spacing`, and the frequent
mislabeling of echo spacing (which is spacing in the phase encoding direction)
as "dwell time" (which is spacing in the readout direction).
"""
@defprop DwellTime{:dwell_time}::F64Sec

"""
Returns the user specified time (in seconds) to delay the acquisition of data for
the following volume. If the field is not present it is assumed to be set to zero.
Corresponds to Siemens CSA header field ldelay_timeInTR. This field is REQUIRED
for sparse sequences using the repetition_time field that do not have the
slice_timing field set to allowed for accurate calculation of "acquisition time".
This field is mutually exclusive with `volume_timing`.
"""
@defprop DelayTime{:delay_time}::F64Sec

"""
Duration (in seconds) of volume acquisition. This field is REQUIRED for
sequences that are described with the `volume_timingfield` and that do not have the
`slice_timing` field set to allowed for accurate calculation of "acquisition time".
This field is mutually exclusive with `repetition_time`.
"""
@defprop AcquisitionDuration{:acquisition_duration}::F64Sec

"""
Returns duration (in seconds) from trigger delivery to scan onset. This delay is
commonly caused by adjustments and loading times. This specification is entirely
independent of number_of_volumes_discarded_by_scanner or number_of_volumes_discarded_by_user,
as the delay precedes the acquisition.
"""
@defprop DelayAfterTrigger{:delay_after_trigger}::F64Sec

"""
Returns the time at which each volume was acquired during the acquisition. It is
described using a list of times (in JSON format) referring to the onset of each
volume in the BOLD series. The list must have the same length as the BOLD
series, and the values must be non-negative and monotonically increasing. This
field is mutually exclusive with repetition_time and delay_time. If defined, this
requires acquisition time (TA) be defined via either slice_timing or
acquisition_duration be defined.
"""
@defprop VolumeTiming{:volume_timing}::Vector{F64Sec}

"""
Returns the time in seconds between the beginning of an acquisition of one volume
and the beginning of acquisition of the volume following it (TR). Please note that
this definition includes time between scans (when no data has been acquired) in
case of sparse acquisition schemes. This value needs to be consistent with the
pixdim[4] field (after accounting for units stored in xyzt_units field) in the
NIfTI header. This field is mutually exclusive with volume_timing and is derived
from DICOM Tag 0018, 0080 and converted to seconds.
"""
@defprop RepetitionTime{:repetition_time}::F64Sec

"""
Returns the inversion time (TI) for the acquisition, specified in seconds.
Inversion time is the time after the middle of inverting RF pulse to middle of
excitation pulse to detect the amount of longitudinal magnetization.
"""
@defprop InversionTime{:inversion_time}::F64Sec
