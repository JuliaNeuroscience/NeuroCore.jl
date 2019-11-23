neuroproperty(:freqdim, "FrequencyDimension", Int, 0)

neuroproperty(
    :slicedim,
    "SliceDimension",
    Int,
    0,
    property_def="The dimension where slices were acquired at throughout MRI acquisition"
)

neuroproperty(
    :phasedim,
    "PhaseDimension",
    Int,
    0,
    property_def="Which spatial dimension (1, 2, or 3) corresponds to phase acquisition."
)

neuroproperty(
    :slice_start,
    "SliceStart",
    Int,
    1,
    property_def="""
    Which slice corresponds to the first slice acquired during MRI acquisition
    (i.e. not padded slices). Defaults to `1`.
    """
)

neuroproperty(
    :slice_end,
    "SliceEnd",
    Int,
    0,
    property_def="""
    Which slice corresponds to the last slice acquired during MRI acquisition
    (i.e. not padded slices).
    """
)

neuroproperty(
    :slice_end,
    "SliceDuration",
    Float64,
    1.0,
    property_def="""
    The amount of time necessary to acquire each slice throughout the MRI
    acquisition.
    """
)

neuroproperty(
    :echo_time,
    "EchoTime",
    Float64,
    1.0,
    property_def="""
    The echo time (TE) for the acquisition.

    This parameter is REQUIRED if corresponding fieldmap data is present or the
    data comes from a multi echo sequence.

    please note that the DICOM term is in milliseconds not seconds
    """,
    dicom_tag=(0x0018, 0x0081)
)

neuroproperty(
    :inversion_time,
    "InversionTime",
    Float64,
    1.0,
    property_def="""
    The inversion time (TI) for the acquisition, specified in seconds. Inversion
    time is the time after the middle of inverting RF pulse to middle of excitation
    pulse to detect the amount of longitudinal magnetization.

    Please note that the DICOM term is in milliseconds not seconds
    """,
    dicom_tag=(0x0018, 0x0082)
)

neuroproperty(
    :slice_time,
    "SliceTime",
    Float64,
    1.0,
    property_def="""
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
)

neuroproperty(
    :dwell_time,
    "DwellTime",
    Float64,
    1.0,
    property_def="""
    Actual dwell time (in seconds) of the receiver per point in the readout
    direction, including any oversampling. For Siemens, this corresponds to DICOM
    field (0019,1018) (in ns). This value is necessary for the optional readout
    distortion correction of anatomicals in the HCP Pipelines. It also usefully
    provides a handle on the readout bandwidth, which isn’t captured in the other
    metadata tags. Not to be confused with `EffectiveEchoSpacing`, and the frequent
    mislabeling of echo spacing (which is spacing in the phase encoding direction)
    as "dwell time" (which is spacing in the readout direction).
    """,
    dicom_tag=(0x0019, 0x1018)
)

neuroproperty(
    :repitition_time,
    "RepititionTime",
    Float64,
    1.0,
    property_def="""
    The time in seconds between the beginning of an acquisition of one volume and
    the beginning of acquisition of the volume following it (TR). Please note that
    this definition includes time between scans (when no data has been acquired) in
    case of sparse acquisition schemes. This value needs to be consistent with the
    pixdim[4] field (after accounting for units stored in xyzt_units field) in the
    NIfTI header. This field is mutually exclusive with VolumeTiming and is derived
    from DICOM Tag 0018, 0080 and converted to seconds.
    """,
    dicom_tag=(0x0018,0x0080)
)

#= TODO
"""
    voltime(x)

The time at which each volume was acquired during the acquisition. It is
described using a list of times (in JSON format) referring to the onset of each
volume in the BOLD series. The list must have the same length as the BOLD
series, and the values must be non-negative and monotonically increasing. This
field is mutually exclusive with RepetitionTime and delay_time. If defined, this
requires acquisition time (TA) be defined via either SliceTiming or
AcquisitionDuration be defined.
"""
voltime
jsontag(::typeof(voltime)) = "VolumeTiming"
=#

neuroproperty(
    :delay_time,
    "DelayTime",
    Float64,
    1.0,
    property_def="""
    User specified time (in seconds) to delay the acquisition of data for the
    following volume. If the field is not present it is assumed to be set to zero.
    Corresponds to Siemens CSA header field ldelay_timeInTR. This field is REQUIRED
    for sparse sequences using the RepetitionTime field that do not have the
    SliceTiming field set to allowed for accurate calculation of "acquisition time".
    This field is mutually exclusive with VolumeTiming.
    """
)

neuroproperty(
    :acquisition_duration,
    "AcquisitionDuration",
    Float64,
    1.0,
    property_def="""
    Duration (in seconds) of volume acquisition. This field is REQUIRED for
    sequences that are described with the VolumeTimingfield and that not have the
    SliceTiming field set to allowed for accurate calculation of "acquisition time".
    This field is mutually exclusive with RepetitionTime.
    """,
    dicom_tag=(0x0018, 0x9073)
)

neuroproperty(
    :delay_after_trigger,
    "DelayAfterTrigger",
    Float64,
    1.0,
    property_def="""
    Duration (in seconds) from trigger delivery to scan onset. This delay is
    commonly caused by adjustments and loading times. This specification is
    entirely independent of NumberOfVolumesDiscardedByScanner or
    NumberOfVolumesDiscardedByUser, as the delay precedes the acquisition.
    """
)

neuroproperty(
    :start_time,
    "StartTime",
    Float64,
    1.0,
    property_def="""
    Start time in seconds in relation to the start of acquisition of the first data
    sample in the corresponding neural dataset (negative values are allowed).
    """
)

neuroproperty(
    :nvol_user_discarded,
    "NumberOfVolumesDiscardedByUser",
    Int,
    0,
    property_def="""
    Number of volumes ("dummy scans") discarded by the user before including the
    file in the dataset. If possible, including all of the volumes is strongly
    recommended. Please note that the onsets recorded in the _event.tsv file
    should always refer to the beginning of the acquisition of the first volume in
    the corresponding imaging file - independent of the value of
    NumberOfVolumesDiscardedByUser field.
    """
)

neuroproperty(
    :nvol_scanner_discarded,
    "NumberOfVolumesDiscardedByScanner",
    Int,
    0,
    property_def="""
    Number of volumes ("dummy scans") discarded by the scanner (as opposed to those
    discarded by the user post hoc) before saving the imaging file. For example, a
    sequence that automatically discards the first 4 volumes before saving would
    have this field as 4. A sequence that doesn't discard dummy scans would have
    this set to 0. Please note that the onsets recorded in the _event.tsv file
    should always refer to the beginning of the acquisition of the first volume in
    the corresponding imaging file - independent of the value of
    NumberOfVolumesDiscardedByScanner field.
    """
)

neuroproperty(
    :institution_name,
    "InstitutionName",
    String,
    "",
    property_def="The name of the institution in charge of the equipment that produced the composite instances.",
    dicom_tag = (0x0008,0x0080)
)

neuroproperty(
    :institution_address,
    "InstitutionAddress",
    String,
    "",
    property_def="The address of the institution in charge of the equipment that produced the composite instances.",
    dicom_tag = (0x0008,0x0081)
)

neuroproperty(
    :institutional_department_name,
    "InstitutionalDepartmentName",
    String,
    "",
    property_def="The department in the institution in charge of the equipment that produced the composite instances.",
    dicom_tag=(0x0008,0x1040)
)

neuroproperty(
    :station_name,
    "StationName",
    String,
    "",
    property_def="Institution defined name of the machine that produced the composite instances.",
    dicom_tag=(0x0008, 0x1010)
)

neuroproperty(
    :manufacturer,
    "Manufacturer",
    String,
    "",
    property_def="Manufacturer of the equipment that produced the composite instances.",
    dicom_tag=(0x0008, 0x0070)
)

neuroproperty(
    :manufacturer_model_name,
    "ManufacturerModelName",
    String,
    "",
    property_def="Manufacturer's model name of the equipment that produced the composite instances.",
    dicom_tag=(0x0008, 0x1090)
)

#= TODO: What type is serial number going to be?
@property(manufacturer_model_name, "Manufacturer", x -> String, x -> )
"""
    device_serial_number(x) -> Number

The serial number of the equipment that produced the composite instances.
A pseudonym can also be used to prevent the equipment from being identifiable,
so long as each pseudonym is unique within the dataset.
"""
device_serial_number(x::Any) = 0
dicomtag(typeof(device_serial_number)) = (0x0018, 0x1000)
jsontag(::typeof(device_serial_number)) = "DeviceSerialNumber"
=#


#= TODO: determine type
@property(manufacturer_model_name, "Manufacturer", x -> String, x -> "")
"""
    software_versions(x) -> Vector

Manufacturer’s designation of software version of the equipment that produced
the composite instances.
"""
software_versions(x::Any) = ""
dicomtag(::typeof(software_versions)) = (0x0018, 0x1020)
jsontag(::typeof(software_versions)) = "SoftwareVersions"
=#


neuroproperty(
    :magnetic_field_strength,
    "MagneticFieldStrength",
    Float64,
    1.0,
    property_def="Nominal field strength of MR magnet in Tesla.",
    dicom_tag=(0x0018,0x0087)
)

neuroproperty(
    :receiver_coil_name,
    "ReceiverCoilName",
    String,
    "",
    property_def="""
    Information describing the receiver coil. Corresponds to DICOM Tag
    Receive Coil Name, although not all vendors populate that DICOM Tag, in which
    case this field can be derived from an appropriate private DICOM field.
    """,
    dicom_tag=(0x0018, 0x1250)
)

neuroproperty(
    :receive_coil_active_elements,
    "ReceiveCoilActiveElements",
    String,
    "",
    property_def="""
    Information describing the active/selected elements of the receiver coil. This
    doesn’t correspond to a tag in the DICOM ontology. The vendor-defined
    terminology for active coil elements can go in this field. As an example, for
    Siemens, coil channels are typically not activated/selected individually, but
    rather in pre-defined selectable "groups" of individual channels, and the list
    of the "groups" of elements that are active/selected in any given scan
    populates the Coil String entry in Siemens’ private DICOM fields (e.g., HEA;HEP
    for the Siemens standard 32 ch coil when both the anterior and posterior groups
    are activated). This is a flexible field that can be used as most appropriate
    for a given vendor and coil to define the "active" coil elements. Since
    individual scans can sometimes not have the intended coil elements selected, it
    is preferable for this field to be populated directly from the DICOM for each
    individual scan, so that it can be used as a mechanism for checking that a
    given scan was collected with the intended coil elements selected.

    * Support suggestion: recommended
    """
)

neuroproperty(
    :gradient_set_type,
    "GradientSetType",
    String,
    "",
    property_def="""
    It should be possible to infer the gradient coil from the scanner model. If
    not, e.g. because of a custom upgrade or use of a gradient insert set, then the
    specifications of the actual gradient coil should be reported independently.

    * Support suggestion: recommended
    """
)

neuroproperty(
    :matrix_coil_mode,
    "MatrixCoilMode",
    String,
    "",
    property_def="""
    A method for reducing the number of independent channels by combining in analog
    the signals from multiple coil elements. There are typically different default
    modes when using un-accelerated or accelerated (e.g. GRAPPA, SENSE) imaging.
    """
)

neuroproperty(
    :coil_combination_method,
    "CoilCombinationMethod",
    String,
    "",
    property_def="""
    Almost all fMRI studies using phased-array coils use root-sum-of-squares (rSOS)
    combination, but other methods exist. The image reconstruction is changed by
    the coil combination method (as for the matrix coil mode above), so anything
    non-standard should be reported
    """
)

neuroproperty(
    :flip_angle,
    "FlipAngle",
    Int,
    0,
    property_def="Flip angle for the acquisition in degrees.",
    dicom_tag = (0x0018,0x1314)
)

neuroproperty(
    :multiband_acceleration_factor
    "MultibandAccelerationFactor",
    String,
    "",
    property_def="The multiband factor, for multiband acquisitions."
)

"""
    negative_contrast -> Bool
"""
function negative_contrast end
json_tag(::typeof(negative_contrast)) = "NegativeContrast"

# TODO contrast_bolus_ingredient
"""
    contrast_bolus_ingredient(x) = ""

Active ingredient of agent. Values MUST be one of: IODINE, GADOLINIUM,
CARBON DIOXIDE, BARIUM, XENON.
"""
contrast_bolus_ingredient(x::Any) = ""
dicom_tag(::typeof(contrast_bolus_ingredient)) = (0x0018,0x1048)
json_tag(::typeof(contrast_bolus_ingredient)) = "ContrastBolusIngredient"

#= TODO
Name	contrast_label	Description
BOLD	bold	Blood-Oxygen-Level Dependent contrast (specialized T2* weighting)
CBV	cbv	Cerebral Blood Volume contrast (specialized T2* weighting or difference between T1 weighted images)
Phase	phase	Phase information associated with magnitude information stored in BOLD contrast
=#

neuroproperty(
    :pulse_sequence,
    "PulseSequence",
    String,
    "",
    property_def="""
    A general description of the pulse sequence used for the scan (i.e. MPRAGE,
    Gradient Echo EPI, Spin Echo EPI, Multiband gradient echo EPI).
    """
)

neuroproperty(
    :scanning_sequence,
    "ScanningSequence",
    String,
    "",
    property_def="Description of the type of data acquired.",
    dicom_tag=(0x0018, 0x0020)
)

neuroproperty(
    :sequence_variant,
    "SequenceName",
    String,
    "",
    property_def="Variant of the ScanningSequence.",
    dicom_tag=(0x0018,0x0021)
)

# TODO: scan_options
"""
    scan_options

Parameters of ScanningSequence. Corresponds to DICOM Tag 0018, 0022
`Scan Options`.
"""
scan_options

neuroproperty(
    :sequence_name,
    "SequenceName",
    String,
    "",
    property_def="Manufacturer’s designation of the sequence name.",
    dicom_tag=(0x0018,0x0024)
)

# TODO pulse_sequence_details
"""
    pulse_sequence_details

Information beyond pulse sequence type that identifies the specific pulse
sequence used (i.e. "Standard Siemens Sequence distributed with the VB17
software," "Siemens WIP ### version #.##," or "Sequence written by X using a
version compiled on MM/DD/YYYY"). |
"""
function pulse_sequence_details end

neuroproperty(
    :nonlinear_gradient_correction
    "NonlinearGradientCorrection",
    Bool,
    false,
    property_def="""
    Stating if the image saved has been corrected for gradient nonlinearities by
    the scanner sequence.
    """
)

neuroproperty(
    :event_onset,
    "EventOnset",
    Float64,
    0.0,
    property_def="""
    Onset (in seconds) of the event measured from the beginning of the acquisition
    of the first volume in the corresponding task imaging data file. If any acquired
    scans have been discarded before forming the imaging data file, ensure that a
    time of 0 corresponds to the first image stored. In other words negative numbers
    in "onset" are allowed.
    """
)

neuroproperty(
    :event_duration,
    "EventDuration",
    Float64,
    0.0,
    property_def="""
    Duration of the event (measured from onset) in seconds. Must always be either
    zero or positive. A "duration" value of zero implies that the delta function or
    event is so short as to be effectively modeled as an impulse.
    """
)

neuroproperty(
    :trial_type,
    "TrialType",
    String,
    "",
    property_def="""
    Primary categorisation of each trial to identify them as instances of the
    experimental conditions. For example: for a response inhibition task, it
    could take on values "go" and "no-go" to refer to response initiation and
    response inhibition experimental conditions.
    """
)

neuroproperty(
    :response_time,
    "ResponseTime",
    Float64,
    NaN,
    property_def="""
    OPTIONAL. Response time measured in seconds. A negative response time can
    be used to represent preemptive responses and "n/a" denotes a missed
    response.
    """
)

neuroproperty(
    :stimulus_file,
    "StimulusFile",
    String,
    "",
    property_def="""
    OPTIONAL. Represents the location of the stimulus file (image, video,
    sound etc.) presented at the given onset time. There are no restrictions on
    the file formats of the stimuli files, but they should be stored in the
    /stimuli folder (under the root folder of the dataset; with optional
    subfolders). The values under the stim_file column correspond to a path
    relative to "/stimuli". For example "images/cat03.jpg" will be translated
    to "/stimuli/images/cat03.jpg".
    """
)

# TODO: event_marker type
neuroproperty(
    :event_marker,
    "EventMarker",
    String,
    "",
    property_def="""
    OPTIONAL. Marker value associated with the event (e.g., the value of a TTL
    trigger that was recorded at the onset of the event).
    """
)

neuroproperty(
    :event_description,
    "EventDescription",
    String,
    "",
    property_def="""
    OPTIONAL. Hierarchical Event Descriptor (HED) Tag. See Appendix III for details.
    """
)

_caltype(x::AbstractArray{T}) where {T} = T
_caltype(x::Any) = Float64
_calmin(x::AbstractArray) = minimum(x)
_calmax(x::AbstractArray) = maximum(x)
_calmin(x::Any) = one(Float64)
_calmax(x::Any) = one(Float64)

neuroproperty(
    :calmax,
    "CalibrationMaximum",
    _caltype,
    _calmax,
    property_def="""
    Specifies maximum element for display purposes. Defaults to the maximum of `x`.
    """
)

neuroproperty(
    :calmin,
    "CalibrationMinimum",
    _caltype,
    _calmin,
    property_def="""
    Specifies minimum element for display purposes. Defaults to the maximum of `x`.
    """
)

neuroproperty(
    :magic_bytes,
    "MagicBytes",
    Vector{UInt8},
    UInt8[],
    property_def="""
    Retrieves the magic_bytes associated with the file that produced an image
    instance. Defaults to `[0x00]` if not found.
    """
)

neuroproperty(
    :nshots,
    "NumberRFExcitations",
    Int,
    0,
    property_def="""
    The number of RF excitations need to reconstruct a slice or volume. Please mind
    that this is not the same as Echo Train Length which denotes the number of
    lines of k-space collected after an excitation.
    """
)

#= TODO
neuroproperty(
    :parallel_reduction_factor_in_plane,
    "ParallelReductionFactorInPlane"

"""
The parallel imaging (e.g, GRAPPA) factor. Use the denominator of the fraction
of k-space encoded for each slice. For example, 2 means half of k-space is
encoded. Corresponds to DICOM Tag 0018, 9069 `Parallel Reduction Factor
In-plane`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |

    parallel_reduction_factor_inplane

Measurement time reduction factor expressed as ratio of original and reduced
measurement time for the in-plane direction. Required if Frame Type (0008,9007)
Value 1 of this frame is ORIGINAL and Parallel Acquisition (0018,9077) equals
YES. Otherwise may be present if Frame Type (0008,9007) Value 1 is DERIVED and
Parallel Acquisition (0018,9077) equals YES.
"""
function parallel_reduction_factor_inplane end
dicomtag(::typeof(parallel_reduction_factor_inplane)) = (0x0018,0x9069)
=#

neuroproperty(
    :parallel_acquisition_technique
    "ParallelAcquisitionTechnique",
    String,
    "",
    property_def="The type of parallel imaging used (e.g. GRAPPA, SENSE).",
    dicom_tag=(0x0018,0x9078)
)

# TODO check partial fourier
neuroproperty(
    :partial_fourier,
    "PartialFourier",
    Float64,
    1.0,
    property_def="The fraction of partial Fourier information collected.",
    dicom_tag=(0x0018,0x9081)
)

# TODO: partial_fourier_direction type
neuroproperty(
    :partial_fourier_direction,
    "PartialFourierDirection",
    String,
    "",
    property_def="""
    The direction where only partial Fourier information was collected.
    """
    dicom_tag=(0x0018,0x9036)
)

# TODO PhaseEncodingDirection
neuroproperty(
    :phase_encoding_direction,
    "PhaseEncodingDirection",
    String,
    "",
    property_def="""
    Possible values: `i`, `j`, `k`, `i-`, `j-`, `k-`. The letters `i`, `j`, `k`
    correspond to the first, second and third axis of the data in the NIFTI file.
    The polarity of the phase encoding is assumed to go from zero index to maximum
    index unless `-` sign is present (then the order is reversed - starting from
    the highest index instead of zero). `PhaseEncodingDirection` is defined as the
    direction along which phase is was modulated which may result in visible
    distortions. Note that this is not the same as the DICOM term
    `InPlanePhaseEncodingDirection` which can have `ROW` or `COL` values. This
    parameter is REQUIRED if corresponding fieldmap data is present or when using
    multiple runs with different phase encoding directions (which can be later used
    for field inhomogeneity correction).
    """
)

# TODO effective_echo_spacing
neuroproperty(
    :effective_echo_spacing,
    "EffectiveEchoSpacing",
    Float64,
    0.0,
    property_def="""
    The "effective" sampling interval, specified in seconds, between lines in the
    phase-encoding direction, defined based on the size of the reconstructed image
    in the phase direction. It is frequently, but incorrectly, referred to as
    "dwell time" (see `DwellTime` parameter below for actual dwell time). It is
    required for unwarping distortions using field maps. Note that beyond just
    in-plane acceleration, a variety of other manipulations to the phase encoding
    need to be accounted for properly, including partial fourier, phase
    oversampling, phase resolution, phase field-of-view and interpolation.<sup>2</sup>
    This parameter is REQUIRED if corresponding fieldmap data is present.                                                                                                                  |


    <sup>2</sup>Conveniently, for Siemens’ data, this value is easily obtained as
    1/\[`BWPPPE` \* `ReconMatrixPE`\], where BWPPPE is the
    "`BandwidthPerPixelPhaseEncode` in DICOM tag (0019,1028) and ReconMatrixPE is
    the size of the actual reconstructed data in the phase direction (which is NOT
    reflected in a single DICOM tag for all possible aforementioned scan
    manipulations). See [here](https://lcni.uoregon.edu/kb-articles/kb-0003) and
    [here](https://github.com/neurolabusc/dcm_qa/tree/master/In/TotalReadoutTime)
    """
)

neuroproperty(
    :total_readout_time,
    "TotalReadoutTime",
    Float64,
    1.0,
    property_def="""
    This is actually the "effective" total readout time , defined as the readout
    duration, specified in seconds, that would have generated data with the given
    level of distortion. It is NOT the actual, physical duration of the readout
    train. If `EffectiveEchoSpacing` has been properly computed, it is just
    `EffectiveEchoSpacing * (ReconMatrixPE - 1)`.<sup>3</sup> .

    * This parameter is
    REQUIRED if corresponding "field/distortion" maps acquired with opposing phase
    encoding directions are present (see 8.9.4).                                                                                                                                                                                                                                                                                                  |

    <sup>3</sup>We use the "FSL definition", i.e, the time between the center of the
    first "effective" echo and the center of the last "effective" echo.
    """
)
