"""
    time_units(img)

Returns the units (i.e. Unitful.unit) the time axis is measured in. If not available
`nothing` is returned.
"""
time_units(x) = unit(eltype(timeaxis(x)))

"""
    echo_time(x) -> F64Sec

Return the echo time (TE) for the acquisition.

This parameter is REQUIRED if corresponding fieldmap data is present or the
data comes from a multi echo sequence.

please note that the DICOM term is in milliseconds not seconds
"""
echo_time(x) = getter(x, "EchoTime", F64Sec, i -> 1.0u"s")


"""
    echo_time!(x, val)

Set the echo time (TE) for the acquisition.

See also: [`echo_time`](@ref)
"""
echo_time!(x, val) = setter!(x, "EchoTime", F64Sec, val)

"""
    inversion_time(x) -> F64Sec

Returns the inversion time (TI) for the acquisition, specified in seconds.
Inversion time is the time after the middle of inverting RF pulse to middle of
excitation pulse to detect the amount of longitudinal magnetization.

Please note that the DICOM term is in milliseconds not seconds
"""
inversion_time(x) = getter(x, "InversionTime", F64Sec, i -> 1.0u"s")

"""
    inversion_time!(x, val)

Sets the inversion time (TI) for the acquisition, specified in seconds.
"""
inversion_time!(x, val) = setter!(x, "InversionTime", F64Sec, val)

"""
    slice_timing(x) -> Vector{F64Sec}

The time at which each slice was acquired within each volume (frame) of the
acquisition. Slice timing is not slice order -- rather, it is a list of times
(in JSON format) containing the time (in seconds) of each slice acquisition in
relation to the beginning of volume acquisition. The list goes through the
slices along the slice axis in the slice encoding dimension (see below). Note
that to ensure the proper interpretation of the `SliceTiming` field, it is
important to check if the OPTIONAL `SliceEncodingDirection` exists. In
particular, if `SliceEncodingDirection` is negative, the entries in
`SliceTiming` are defined in reverse order with respect to the slice axis
(i.e., the final entry in the `SliceTiming` list is the time of acquisition of
slice 0). This parameter is REQUIRED for sparse sequences that do not have the
`delay_time` field set. In addition without this parameter slice time correction
will not be possible.
"""
slice_timing(x) = getter(x, "SliceTiming", Vector{F64Sec}, i -> F64Sec[])

"""
    slice_timing(x, val)

Set the slice timing.

See also: ['slice_timing'](@ref)
"""
slice_timing!(x, val) = setter!(x, "SliceTiming", Vector{F64Sec}, val)

"""
    dwell_time(x) -> F64Sec

Actual dwell time (in seconds) of the receiver per point in the readout
direction, including any oversampling. For Siemens, this corresponds to DICOM
field (0019,1018) (in ns). This value is necessary for the optional readout
distortion correction of anatomicals in the HCP Pipelines. It also usefully
provides a handle on the readout bandwidth, which isn’t captured in the other
metadata tags. Not to be confused with `EffectiveEchoSpacing`, and the frequent
mislabeling of echo spacing (which is spacing in the phase encoding direction)
as "dwell time" (which is spacing in the readout direction).
"""
dwell_time(x) = getter(x, "DwellTime", F64Sec, i -> 1.0u"s")

"""
    dwell_time!(x, val)

Sets the dwell time.

See also: [`dwell_time`](@ref)
"""
dwell_time!(x, val) = setter!(x, "DwellTime", F64Sec, val)


"""
    repetition_time(x) -> F64Sec

Returns the time in seconds between the beginning of an acquisition of one volume
and the beginning of acquisition of the volume following it (TR). Please note that
this definition includes time between scans (when no data has been acquired) in
case of sparse acquisition schemes. This value needs to be consistent with the
pixdim[4] field (after accounting for units stored in xyzt_units field) in the
NIfTI header. This field is mutually exclusive with VolumeTiming and is derived
from DICOM Tag 0018, 0080 and converted to seconds.
"""
repitition_time(x) = getter(x, "RepititionTime", F64Sec, i -> 1.0u"s")

"""
    repitition_time!(x, val)

Sets the repitition time.

See also: [`repitition_time`](@ref)
"""
repitition_time!(x, val) = setter!(x, "RepititionTime", F64Sec, val)

"""
    volume_timing(x) -> Vector{F64Sec}

Returns the time at which each volume was acquired during the acquisition. It is
described using a list of times (in JSON format) referring to the onset of each
volume in the BOLD series. The list must have the same length as the BOLD
series, and the values must be non-negative and monotonically increasing. This
field is mutually exclusive with RepetitionTime and delay_time. If defined, this
requires acquisition time (TA) be defined via either SliceTiming or
AcquisitionDuration be defined.
"""
volume_timing(x) = getter(x, "VolumeTiming", Vector{F64Sec}, i -> F64Sec[])

"""
    volume_timing!(x, val)

Sets the volume timing.

See also: [`volume_timing`](@ref)
"""
volume_timing!(x, val) = setter!(x, "VolumeTiming", Vector{F64Sec}, val)

"""
    delay_time(x) -> F64Sec

Returns the user specified time (in seconds) to delay the acquisition of data for
the following volume. If the field is not present it is assumed to be set to zero.
Corresponds to Siemens CSA header field ldelay_timeInTR. This field is REQUIRED
for sparse sequences using the RepetitionTime field that do not have the
SliceTiming field set to allowed for accurate calculation of "acquisition time".
This field is mutually exclusive with VolumeTiming.
"""
delay_time(x) = getter(x, "DelayTime", F64Sec, i -> 1.0u"s")

"""
    delay_time!(x, val)

Sets the delay time.

See also: [`delay_time`](@ref)
"""
delay_time!(x, val) = setter!(x, "DelayTime", F64Sec, val)

"""
    acqduration(x) -> F64Sec

Duration (in seconds) of volume acquisition. This field is REQUIRED for
sequences that are described with the VolumeTimingfield and that not have the
SliceTiming field set to allowed for accurate calculation of "acquisition time".
This field is mutually exclusive with RepetitionTime.
"""
acqduration(x) = getter(x, "AcquisitionDuration", F64Sec, i -> 1.0u"s")

"""
    acqduration!(x, val)

Set the acquisition duration.

See also: ['acqduration'](@ref)
"""
acqduration!(x, val) = setter!(x, "AcquisitionDuration", F64Sec, val)

"""
    delay_after_trigger(x) -> F64Sec

Returns duration (in seconds) from trigger delivery to scan onset. This delay is
commonly caused by adjustments and loading times. This specification is entirely
independent of NumberOfVolumesDiscardedByScanner or NumberOfVolumesDiscardedByUser,
as the delay precedes the acquisition.
"""
delay_after_trigger(x) = getter(x, "DelayAfterTrigger", F64Sec, i -> 1.0u"s")

"""
    delay_after_trigger!(x, val)

Sets "DelayAfterTrigger" property.

See also: [`delay_after_trigger`](@ref).
"""
delay_after_trigger!(x, val) = setter!(x, "DelayAfterTrigger", F64Sec, val)

"""
    start_time(x) -> F64Sec

Returns start time in seconds in relation to the start of acquisition of the first
data sample in the corresponding neural dataset (negative values are allowed).
"""
start_time(x) = maybe_ustrip(first(timeaxis(x)))
