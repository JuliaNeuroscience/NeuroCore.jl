"""
    acquisition_duration(x) -> F64Sec

Duration (in seconds) of volume acquisition. This field is REQUIRED for
sequences that are described with the volume_timingfield and that do not have the
slice_timing field set to allowed for accurate calculation of "acquisition time".
This field is mutually exclusive with repetition_time.

Corresponds to BIDS "AcquisitionDuration".
"""
acquisition_duration(x) = getter(x, :acquisition_duration, F64Sec, i -> 1.0u"s")
acquisition_duration!(x, val) = setter!(x, :acquisition_duration, F64Sec, val)

"""
    anatomical_landmark_coordinates(x) -> CoordinateList

Key:value pairs of any number of additional anatomical landmarks and their coordinates
in voxel units (where first voxel has index 0,0,0) relative to the associated anatomical
MRI, (e.g. Dict(:AC => (127.0,119.0,149.0), :PC=> (128.0,93.0,141.0),
:IH=> (131.0114.0,206.0)).

Corresponds to BIDS "AnatomicalLandmarkCoordinates".
"""
anatomical_landmark_coordinates(x) = getter(x, :anatomical_landmark_coordinates, CoordinateList, i -> CoordinateList())
anatomical_landmark_coordinates!(x, val) = setter!(x, :anatomical_landmark_coordinates, CoordinateList, val)

"""
    anatomical_landmark_coordinate_system(x)

Defines the coordinate system for the anatomical landmarks. See [`CoordinateSystem`](@ref).

Corresponds to BIDS "AnatomicalLandmarkCoordinateSystem".
"""
anatomical_landmark_coordinate_system(x) = coordinate_system(x)

"""
    anatomical_landmark_coordinate_units(x)

Units of the coordinates of anatomical_landmark_coordinate_system. MUST be m, cm, or mm.

Corresponds to BIDS "AnatomicalLandmarkCoordinateUnits"
"""
anatomical_landmark_coordinate_units(x) = spatial_units(x)

"""
anatomical_landmark_coordinate_systemDescription

Freeform text description or link to document describing the anatomical coordinate
system detail.

Corresponds to BIDS "AnatomicalLandmarkCoordinateSystemDescription"
"""
anatomical_landmark_coordinate_system_description(x) = getter(x, :anatomical_landmark_coordinate_system_description, String, i -> "")
anatomical_landmark_coordinate_system_description!(x, val) = setter!(x, :anatomical_landmark_coordinate_system_description, String, val)

"""
    coil_combination_method(x) -> String

Returns the coil combination method.

Almost all fMRI studies using phased-array coils use root-sum-of-squares (rSOS)
combination, but other methods exist. The image reconstruction is changed by
the coil combination method (as for the matrix coil mode above), so anything
non-standard should be reported.

Corresponds to BIDS "CoilCombinationMethod"
"""
coil_combination_method(x) =  getter(x, :coil_combination_method, String, i -> "rSOS")
coil_combination_method!(x, val) =  setter!(x, :coil_combination_method, String, val)

"""
    CogAtlasID(x) -> String

URL of the corresponding [Cognitive Atlas Task](https://www.cognitiveatlas.org/) term.
"""
CogAtlasID(x) =  getter(x, :CogAtlasID, String, i -> "")
CogAtlasID!(x, val) =  setter!(x, :CogAtlasID, String, val)

"""
    CogPOID(x) -> String

URL of the corresponding [CogPO](http://www.cogpo.org/) term.
"""
CogPOID(x) =  getter(x, :CogPOID, String, i -> "")
CogPOID!(x, val) =  setter!(x, :CogPOID, String, val)

"""
    contrast_bolus_ingredient(x) -> String

Return active ingredient of constrast agent. See [`ContrastIngrediant`](@ref) for
more details.

Corresponds to BIDS "ContrastBolusIngredient".
"""
contrast_bolus_ingredient(x) = getter(x, :contrast_bolus_ingredient, ContrastIngrediant, i -> UnkownContrast)
contrast_bolus_ingredient!(x, val) = setter!(x, :contrast_bolus_ingredient, ContrastIngrediant, val)

"""
    delay_time(x) -> F64Sec

Returns the user specified time (in seconds) to delay the acquisition of data for
the following volume. If the field is not present it is assumed to be set to zero.
Corresponds to Siemens CSA header field ldelay_timeInTR. This field is REQUIRED
for sparse sequences using the repetition_time field that do not have the
slice_timing field set to allowed for accurate calculation of "acquisition time".
This field is mutually exclusive with volume_timing.

Corresponds to BIDS "DelayTime".
"""
delay_time(x) = getter(x, :delay_time, F64Sec, i -> 1.0u"s")
delay_time!(x, val) = setter!(x, :delay_time, F64Sec, val)

"""
    delay_after_trigger(x) -> F64Sec

Returns duration (in seconds) from trigger delivery to scan onset. This delay is
commonly caused by adjustments and loading times. This specification is entirely
independent of number_of_volumes_discarded_by_scanner or number_of_volumes_discarded_by_user,
as the delay precedes the acquisition.

Corresponds to BIDS "DelayAfterTrigger".
"""
delay_after_trigger(x) = getter(x, :delay_after_trigger, F64Sec, i -> 1.0u"s")
delay_after_trigger!(x, val) = setter!(x, :delay_after_trigger, F64Sec, val)

"""
    device_serial_number(x) -> String

The serial number of the equipment that produced the composite instances.
A pseudonym can also be used to prevent the equipment from being identifiable,
so long as each pseudonym is unique within the dataset.

Corresponds to BIDS "DeviceSerialNumber".
"""
device_serial_number(x) = getter(x, :device_serial_number, String, i -> "00000")
device_serial_number!(x, val) = setter!(x, :device_serial_number, String, val)

"""
    dewar_position(x)

Position of the dewar during the MEG scan: upright, supine or degrees of angle
from vertical: for example on CTF systems, upright=15°, supine = 90°.

Corresponds to BIDS "DewarPosition".
"""
dewar_position(x) = getter(x, :dewar_position, IntDeg, i -> OneIntDeg)
dewar_position!(x, val) = setter!(x, :dewar_position, IntDeg, val)

"""
    dwell_time(x) -> F64Sec

Actual dwell time (in seconds) of the receiver per point in the readout
direction, including any oversampling. For Siemens, this corresponds to DICOM
field (0019,1018) (in ns). This value is necessary for the optional readout
distortion correction of anatomicals in the HCP Pipelines. It also usefully
provides a handle on the readout bandwidth, which isn’t captured in the other
metadata tags. Not to be confused with `effective_echo_spacing`, and the frequent
mislabeling of echo spacing (which is spacing in the phase encoding direction)
as "dwell time" (which is spacing in the readout direction).

Corresponds to BIDS "DwellTime".
"""
dwell_time(x) = getter(x, :dwell_time, F64Sec, i -> 1.0u"s")
dwell_time!(x, val) = setter!(x, :dwell_time, F64Sec, val)

"""
    echo_time(x) -> F64Sec

The echo time (TE) for the acquisition. This parameter is REQUIRED if corresponding
fieldmap data is present or the data comes from a multi echo sequence.

Corresponds to BIDS "EchoTime".
"""
echo_time(x) = getter(x, :echo_time, F64Sec, i -> 1.0u"s")
echo_time!(x, val) = setter!(x, :echo_time, F64Sec, val)

"""
    effective_echo_spacing(x) -> F64Sec

Returns the effective echo spacing.

The "effective" sampling interval, specified in seconds, between lines in the
phase-encoding direction, defined based on the size of the reconstructed image
in the phase direction. It is frequently, but incorrectly, referred to as
"dwell time" (see `dwell_time` parameter below for actual dwell time). It is
required for unwarping distortions using field maps. Note that beyond just
in-plane acceleration, a variety of other manipulations to the phase encoding
need to be accounted for properly, including partial fourier, phase
oversampling, phase resolution, phase field-of-view and interpolation.<sup>2</sup>
This parameter is REQUIRED if corresponding fieldmap data is present.

<sup>2</sup>Conveniently, for Siemens’ data, this value is easily obtained as
1/[`BWPPPE` * `ReconMatrixPE`], where BWPPPE is the
"`BandwidthPerPixelPhaseEncode` in DICOM tag (0019,1028) and ReconMatrixPE is
the size of the actual reconstructed data in the phase direction (which is NOT
reflected in a single DICOM tag for all possible aforementioned scan
manipulations). See [here](https://lcni.uoregon.edu/kb-articles/kb-0003) and
[here](https://github.com/neurolabusc/dcm_qa/tree/master/In/total_readout_time)

Corresponds to BIDS "EffectiveEchoSpacing".
"""
effective_echo_spacing(x) = getter(x, :effective_echo_spacing, F64Sec, i -> 1.0u"s")
effective_echo_spacing!(x, val) = setter!(x, :effective_echo_spacing, F64Sec, val)

"""
    eeg_electrode_groups(x) -> String

Field to describe the way electrodes are grouped into strips, grids or depth probes
e.g., `Dict(:grid1 => "10x8 grid on left temporal pole", :strip2 => "1x8 electrode strip on xxx")`.

Corresponds to BIDS "EEGElectrodeGroups".
"""
eeg_electrode_groups(x) = getter(x, :eeg_electrode_groups, Dict{Symbol,String}, i -> Dict{Symbol,String}())
eeg_electrode_groups!(x, val) = setter!(x, :eeg_electrode_groups, Dict{Symbol,String}, val)

"""
    eeg_ground(x) -> String

Description of the location of the ground electrode ("placed on right mastoid (M2)").

Corresponds to BIDS "EEGGround".
"""
eeg_ground(x) = getter(x, :eeg_ground, String, i -> "")
eeg_ground!(x, val) = setter!(x, :eeg_ground, String, val)

"""
    eeg_placement_scheme(x)

Freeform description of the placement of the iEEG electrodes.
Left/right/bilateral/depth/surface (e.g., "left frontal grid and bilateral
hippocampal depth" or "surface strip and STN depth" or "clinical indication
bitemporal, bilateral temporal strips and left grid").

Corresponds to BIDS "EEGPlacementScheme".
"""
eeg_placement_scheme(x) = getter(x, :eeg_placement_scheme, String, i -> "")
eeg_placement_scheme!(x, val) = setter!(x, :eeg_placement_scheme, String, val)

"""
    electrical_stimulation(x) -> Bool

Boolean field to specify if electrical stimulation was done during the recording
(options are `true` or `false`). Parameters for event-like stimulation should be
specified in the _events.tsv file.

Corresponds to BIDS "ElectricalStimulation".
"""
electrical_stimulation(x) = getter(x, :electrical_stimulation, Bool, i -> false)
electrical_stimulation!(x, val) = setter!(x, :electrical_stimulation, Bool, val)

"""
    electrical_stimulation_parameters(x) -> String

Free form description of stimulation parameters, such as frequency, shape etc.
Specific onsets can be specified in the _events.tsv file. Specific shapes can be
described here in freeform text.

Corresponds to BIDS "ElectricalStimulationParameters".
"""
electrical_stimulation_parameters(x) = getter(x, :electrical_stimulation_parameters, String, i -> "")
electrical_stimulation_parameters!(x, val) = setter!(x, :electrical_stimulation_parameters, String, val)

"""
    epoch_length(x) -> F64Sec

Duration of individual epochs in seconds (e.g., 1) in case of epoched data. If
recording was continuous or discontinuous, leave out the field.

Corresponds to BIDS "EpochLength".
"""
epoch_length(x) = getter(x, :epoch_length, F64Sec, OneF64Sec)
epoch_length!(x, val) = setter!(x, :epoch_length, F64Sec, val)

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
    flip_angle(x) -> IntDeg

Returns the flip angle for the acquisition in degrees.

Corresponds to BIDS "FlipAngle".
"""
flip_angle(x) = getter(x, :flip_angle, IntDeg, i -> OneIntDeg)
flip_angle!(x, val) = setter!(x, :flip_angle, IntDeg, val)

"""
    gradient_set_type(x) -> String

Returns the gradient set type. It should be possible to infer the gradient coil
from the scanner model. If not, e.g. because of a custom upgrade or use of a
gradient insert set, then the specifications of the actual gradient coil should
be reported independently.

Corresponds to BIDS "GradientSetType".
"""
gradient_set_type(x) = getter(x, :gradient_set_type, String, i -> "")
gradient_set_type!(x, val) = setter!(x, :gradient_set_type, String, val)

"""
    head_coil_coordinates(x) -> CoordinateList

Key:value pairs describing head localization coil labels and their coordinates,
interpreted following the head_coil_coordinate_system, e.g., {NAS: [12.7,21.3,13.9],
LPA: [5.2,11.3,9.6], RPA: [20.2,11.3,9.1]}. Note that coils are not always placed
at locations that have a known anatomical name (e.g. for Elekta, Yokogawa systems);
in that case generic labels can be used (e.g. {coil1: [12.2,21.3,12.3],
coil2: [6.7,12.3,8.6], coil3: [21.9,11.0,8.1]} ).

Corresponds to BIDS "HeadCoilCoordinates".
"""
head_coil_coordinates(x) = getter(x, :head_coil_coordinates, CoordinateList, i -> CoordinateList())
head_coil_coordinates!(x, val) = setter!(x, :head_coil_coordinates, CoordinateList, val)

"""
    head_coil_coordinate_system(x) -> CoordinateSystem

Defines the coordinate system for the coils.

Corresponds to BIDS "HeadCoilCoordinateSystem".
"""
head_coil_coordinate_system(x) = getter(x, :head_coil_coordinate_system, CoordinateSystem, i -> UnknownSpace)

"""
    head_coil_coordinate_system_description(x) -> String

Freeform text description or link to document describing the Head Coil coordinate
system system in detail.

Corresponds to BIDS "HeadCoilCoordinateSystemDescription".
"""
head_coil_coordinate_system_description(x) = getter(x, :head_coil_coordinate_system_description, String, i -> "")
head_coil_coordinate_system_description!(x, val) = setter!(x, :head_coil_coordinate_system_description, String, val)

"""
    head_coil_coordinate_units(x) -> m, cm, or mm

Units of the coordinates of head_coil_coordinate_system.

Corresponds to BIDS "HeadCoilCoordinateUnits".
"""
head_coil_coordinate_units(x) = spatial_units(x)

"""
    institution_address(x) -> String

Return the address of the institution in charge of the equipment that produced
the composite instances.

Corresponds to BIDS "InstitutionAddress".
"""
institution_address(x) = getter(x, :institution_address, String, i -> "")
institution_address!(x, val) = setter!(x, :institution_address, String, val)

"""
    institutional_department_name(x) -> String

Return the department in the institution in charge of the equipment that produced
the composite instances.

Corresponds to BIDS "InstitutionalDepartmentName".
"""
institutional_department_name(x) = getter(x, :institutional_department_name, String, i -> "")
institutional_department_name!(x, val) = setter!(x, :institutional_department_name, String, val)

"""
    institution_name(x) -> String

Returns the name of the institution in charge of the equipment that produced the
composite instances.

Corresponds to BIDS "InstitutionName".
"""
institution_name(x) = getter(x, :institution_name, String, i -> "")
institution_name!(x, val) = setter!(x, :institution_name, String, val)

"""
    instructions(x) -> String

Text of the instructions given to participants before the scan. This is especially
important in context of resting state fMRI and distinguishing between eyes open and
eyes closed paradigms.

Corresponds to BIDS "Instructions".
"""
instructions(x) = getter(x, :instructions, String, i -> "")
instructions!(x, val) = setter!(x, :instructions, String, val)

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
    inversion_time(x) -> F64Sec

Returns the inversion time (TI) for the acquisition, specified in seconds.
Inversion time is the time after the middle of inverting RF pulse to middle of
excitation pulse to detect the amount of longitudinal magnetization.

Corresponds to BIDS "InversionTime".
"""
inversion_time(x) = getter(x, :inversion_time, F64Sec, i -> 1.0u"s")
inversion_time!(x, val) = setter!(x, :inversion_time, F64Sec, val)

"""
    magnetic_field_strength(x) -> F64Tesla

The nominal field strength of MR magnet in Tesla.

Corresponds to BIDS "MagneticFieldStrength".
"""
magnetic_field_strength(x) = getter(x, :magnetic_field_strength, F64Tesla, i -> 3.0u"T")
magnetic_field_strength!(x, val) = setter!(x, :magnetic_field_strength, F64Tesla, val)

"""
    manufacturer(x) -> String

The manufacturer of the equipment that produced the composite instances.

Corresponds to BIDS "Manufacturer".
"""
manufacturer(x) = getter(x, :manufacturer, String, i -> "")
manufacturer!(x, val) = setter!(x, :manufacturer, String, val)

"""
    manufacturer_model_name(x) -> String

The manufacturer's model name of the equipment that produced the composite instances.

Corresponds to BIDS "ManufacturerModelName".
"""
manufacturer_model_name(x) = getter(x, :manufacturer_model_name, String, i -> "")
manufacturer_model_name!(x, val) = setter!(x, :manufacturer_model_name, String, val)

"""
    matrix_coil_mode(x) -> String

Returns the matrix coil mode. A method for reducing the number of independent
channels by combining in analog the signals from multiple coil elements. There
are typically different default modes when using un-accelerated or accelerated
(e.g. GRAPPA, SENSE) imaging.

Corresponds to BIDS "MatrixCoilMode".
"""
matrix_coil_mode(x) = getter(x, :matrix_coil_mode, String, i -> "")
matrix_coil_mode!(x, val) = setter!(x, :matrix_coil_mode, String, val)

"""
    mr_transmit_coil_sequence(x) -> String

A sequence that provides information about the transmit coil used. This is a
relevant field if a non-standard transmit coil is used.

Corresponds to BIDS "MRTransmitCoilSequence".
"""
mr_transmit_coil_sequence(x) = getter(x, :mr_transmit_coil_sequence, String, i -> "")
mr_transmit_coil_sequence!(x, val) = setter!(x, :mr_transmit_coil_sequence, String, val)

"""
    multiband_acceleration_factor(x) -> String

Returns the multiband factor, for multiband acquisitions.

Corresponds to BIDS "MultibandAccelerationFactor".
"""
multiband_acceleration_factor(x) = getter(x, :multiband_acceleration_factor, String, i -> "")
multiband_acceleration_factor!(x, val) = setter!(x, :multiband_acceleration_factor, String, val)

"""
    negative_contrast(x) -> Bool

Specifies whether increasing voxel intensity (within sample voxels)
denotes a decreased value with respect to the contrast suffix. This is commonly
the case when Cerebral Blood Volume is estimated via usage of a contrast agent
in conjunction with a T2* weighted acquisition protocol.

Corresponds to BIDS "NegativeContrast".
"""
negative_contrast(x) = getter(x, :negative_contrast, Bool, i -> false)
negative_contrast!(x, val) = setter!(x, :negative_contrast, Bool, val)

"""
    nonlinear_gradient_correction(x) -> Bool

Returns `Bool` stating if the image saved has been corrected for gradient
nonlinearities by the scanner sequence. Default is `false`.

Corresponds to BIDS "".
"""
nonlinear_gradient_correction(x) = getter(x, :nonlinear_gradient_correction, Bool, i -> false)
nonlinear_gradient_correction!(x, val) = setter!(x, :nonlinear_gradient_correction, Bool, val)

"""
    number_of_volumes_discarded_by_scanner(x) -> Int

Returns the number of volumes ("dummy scans") discarded by the scanner (as opposed
to those discarded by the user post hoc) before saving the imaging file. For example,
a sequence that automatically discards the first 4 volumes before saving would
have this field as 4. A sequence that doesn't discard dummy scans would have
this set to 0. Please note that the onsets recorded in the _event.tsv file
should always refer to the beginning of the acquisition of the first volume in
the corresponding imaging file - independent of the value of
number_of_volumes_discarded_by_scanner field.

Corresponds to BIDS "NumberOfVolumesDiscardedByScanner".
"""
number_of_volumes_discarded_by_scanner(x) = getter(x, :number_of_volumes_discarded_by_scanner, Int, i -> 0)
number_of_volumes_discarded_by_scanner!(x, val) = setter!(x, :number_of_volumes_discarded_by_scanner, Int, val)

"""
    number_of_volumes_discarded_by_user(x) -> Int

Returns the  number of volumes ("dummy scans") discarded by the user before
including the file in the dataset. If possible, including all of the volumes is
strongly recommended. Please note that the onsets recorded in the _event.tsv file
should always refer to the beginning of the acquisition of the first volume in
the corresponding imaging file - independent of the value of
number_of_volumes_discarded_by_user field.

Corresponds to BIDS "NumberOfVolumesDiscardedByUser".
"""
number_of_volumes_discarded_by_user(x) = getter(x, :number_of_volumes_discarded_by_user, Int, i -> 0)
number_of_volumes_discarded_by_user!(x, val) = setter!(x, :number_of_volumes_discarded_by_user, Int, val)

"""
    number_shots(x) -> Int

Returns the number of RF excitations needed to reconstruct a slice or volume.
Please mind that this is not the same as Echo Train Length which denotes the
number of lines of k-space collected after an excitation.

Corresponds to BIDS "NumberShots".
"""
number_shots(x) = getter(x, :number_shots, Int, i -> 0)
number_shots!(x, val) = setter!(x,  :number_shots, Int, val)

"""
    parallel_acquisition_technique(x) -> String

Returns the type of parallel imaging used (e.g. GRAPPA, SENSE).

Corresponds to BIDS "ParallelAcquisitionTechnique".
"""
parallel_acquisition_technique(x) = getter(x, :parallel_acquisition_technique, String, i -> "")
parallel_acquisition_technique!(x, val) = setter!(x, :parallel_acquisition_technique, String, val)

"""
    parallel_reduction_factor(x) -> Int

The parallel imaging (e.g, GRAPPA) factor. Use the denominator of the fraction
of k-space encoded for each slice. For example, 2 means half of k-space is
encoded.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |

Corresponds to BIDS "ParallelReductionFactor".
"""
parallel_reduction_factor(x) = getter(x, :parallel_reduction_factor, Int, i -> 0)
parallel_reduction_factor!(x, val) = setter!(x, :parallel_reduction_factor, Int, val)

"""
    partial_fourier(x) -> Float64

Returns the fraction of partial Fourier information collected.

Corresponds to BIDS "PartialFourier".
"""
partial_fourier(x) = getter(x, :partial_fourier, Float64, i -> 1.0)
partial_fourier!(x, val) = setter!(x, :partial_fourier, Float64, val)

"""
    partial_fourier_direction(x) -> String

Returns the direction where only partial Fourier information was collected.

Corresponds to BIDS "PartialFourierDirection".
"""
partial_fourier_direction(x) = getter(x, :partial_fourier_direction, String, i -> "")
partial_fourier_direction!(x, val) = setter!(x, :partial_fourier_direction, String, val)

"""
    phase_encoding_direction(x) -> EncodingDirection

Returns the phase encoding direction.

`phase_encoding_direction` is defined as the direction along which phase is was
modulated which may result in visible distortions. Note that this is not the
same as the DICOM term `InPlanephase_encoding_directiong` which can have `ROW` or
`COL` values. This parameter is REQUIRED if corresponding fieldmap data is present
or when using multiple runs with different phase encoding directions (which can
be later used for field inhomogeneity correction).

Corresponds to BIDS "PhaseEncodingDirection".
"""
phase_encoding_direction(x) = EncodingDirection(phasedim(x))
phase_encoding_direction!(x, val) = phasedim!(x, val)

"""
    power_line_frequency(x) -> F64Hz

Frequency (in Hz) of the power grid at the geographical location of the EEG
instrument (i.e., 50 or 60).

Corresponds to BIDS "PowerLineFrequency".
"""
power_line_frequency(x) = getter(x, :power_line_frequency, F64Hz, i -> 1.0u"Hz")
power_line_frequency!(x, val) = setter!(x, :power_line_frequency, F64Hz, val)

"""
    pulse_sequence(x) -> String

General description of the pulse sequence used for the scan (i.e. MPRAGE,
Gradient Echo EPI, Spin Echo EPI, Multiband gradient echo EPI).

Corresponds to BIDS "PulseSequence".
"""
pulse_sequence(x) = getter(x, :pulse_sequence, String, i -> "")
pulse_sequence!(x, val) = setter!(x, :pulse_sequence, String, val)

"""
    pulse_sequence_details(x) -> String

Information beyond pulse sequence type that identifies the specific pulse
sequence used (i.e. "Standard Siemens Sequence distributed with the VB17
software," "Siemens WIP ### version #.##," or "Sequence written by X using a
version compiled on MM/DD/YYYY").

Corresponds to BIDS "PulseSequenceDetails".
"""
pulse_sequence_details(x) = getter(x, :pulse_sequence_details, String, i -> "")
pulse_sequence_details!(x, val) = setter!(x, :pulse_sequence_details, String, val)

"""
    pulse_sequence_type(x) -> String

A general description of the pulse sequence used for the scan (i.e. MPRAGE,
Gradient Echo EPI, Spin Echo EPI, Multiband gradient echo EPI).

Corresponds to BIDS "PulseSequenceType".
"""
pulse_sequence_type(x) = getter(x, :pulse_sequence_type, String, i -> "")
pulse_sequence_type!(x, val) = setter!(x, :pulse_sequence_type, String, val)

"""
    receive_coil_name(x) -> String

The information describing the receiver coil. Corresponds to DICOM Tag
Receive Coil Name, although not all vendors populate that DICOM Tag, in which
case this field can be derived from an appropriate private DICOM field.

Corresponds to BIDS "ReceiveCoilName".
"""
receive_coil_name(x) = getter(x, :receive_coil_name, String, i -> "")
receive_coil_name!(x, val) = setter!(x, :receive_coil_name, String, val)

"""
    receive_coil_active_elements(x) -> String

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

Corresponds to BIDS "ReceiveCoilActiveElements".
"""
receive_coil_active_elements(x) = getter(x, :receive_coil_active_elements, String, i -> "")
receive_coil_active_elements!(x, val) = setter!(x, :receive_coil_active_elements, String, val)

"""
    recording_duration(x) -> F64Sec

Length of the recording in seconds (e.g., 3600)

Corresponds to BIDS "RecordingDuration".
"""
recording_duration(x) = getter(x, :recording_duration, F64Sec, OneF64Sec)
recording_duration!(x, val) = setter!(x, :recording_duration, F64Sec, val)

# TODO: should this return an enumerable
"""
    recording_type(x) -> String

Defines whether the recording is "continuous", "discontinuous" or "epoched";
this latter limited to time windows about events of interest (e.g., stimulus
presentations, subject responses etc.)

Corresponds to BIDS "RecordingType".
"""
recording_type(x) = getter(x, :recording_type, String, i -> "")
recording_type!(x, val) = setter!(x, :recording_type, String, val)

"""
    repetition_time(x) -> F64Sec

Returns the time in seconds between the beginning of an acquisition of one volume
and the beginning of acquisition of the volume following it (TR). Please note that
this definition includes time between scans (when no data has been acquired) in
case of sparse acquisition schemes. This value needs to be consistent with the
pixdim[4] field (after accounting for units stored in xyzt_units field) in the
NIfTI header. This field is mutually exclusive with volume_timing and is derived
from DICOM Tag 0018, 0080 and converted to seconds.

Corresponds to BIDS "RepetitionTime".
"""
repetition_time(x) = getter(x, :repetition_time, F64Sec, i -> 1.0u"s")
repetition_time!(x, val) = setter!(x, :repetition_time, F64Sec, val)

"""
    sampling_frequency -> F64Hz

Sampling frequency (in Hz) of all the data in the recording, regardless of their
type (e.g., 2400).

Corresponds to BIDS "SamplingFrequency".
"""
sampling_frequency(x) = getter(x, :sampling_frequency, F64Hz, i -> 1.0u"Hz")
sampling_frequency!(x, val) = setter!(x, :sampling_frequency, F64Hz, val)

"""
    scan_options(x)

Parameters of scanning_sequence. Corresponds to DICOM  `Scan Options`.

Corresponds to BIDS "ScanOptions".
"""
scan_options(x) = getter(x, :scan_options, Dict{Symbol,Any}, i -> Dict{Symbol,Any}())
scan_options!(x, val) = setter!(x, :scan_options, Dict{Symbol,Any}, val)

# TODO enumerable for bolus ingredient
"""
    scanning_sequence(x) -> String

Returns the description of the type of sequence data acquired.

Corresponds to BIDS "ScanningSequence".
"""
scanning_sequence(x) = getter(x, :scanning_sequence, String, i -> "")
scanning_sequence!(x, val) = setter!(x, :scanning_sequence, String, val)

"""
    sequence_name(x) -> String

Returns the manufacturer’s designation of the sequence name.

Corresponds to BIDS "SequenceName".
"""
sequence_name(x) = getter(x, :sequence_name, String, i -> "")
sequence_name!(x, val) = setter!(x, :sequence_name, String, val)

"""
    sequence_varient(x) -> String

Returns the variant of the `scanning_sequence` property.

Corresponds to BIDS "SequenceVarient".
"""
sequence_varient(x) = getter(x, :sequence_varient, String, i -> "")
sequence_varient!(x, val) = setter!(x, :sequence_varient, String, val)

"""
    slice_encoding_direction(x) -> EncodingDirection

Possible values: `i`, `j`, `k`, `ineg, `jneg`, `kneg` (the axis of the NIfTI data along which
slices were acquired, and the direction in which slice_timing is defined with
respect to). `i`, `j`, `k` identifiers correspond to the first, second and third axis
of the data in the NIfTI file. `*neg` indicates that the contents of
slice_timing are defined in reverse order - that is, the first entry corresponds
to the slice with the largest index, and the final entry corresponds to slice
index zero. When present, the axis defined by slice_encoding_direction needs to be
consistent with the ‘slicedim’ field in the NIfTI header. When absent, the
entries in slice_timing must be in the order of increasing slice index as defined
by the NIfTI header.

Corresponds to BIDS "SliceEncodingDirection".
"""
slice_encoding_direction(x) = EncodingDirection(slicedim(x))
slice_encoding_direction!(x, val) = slicedim!(x, val)

"""
    slice_timing(x) -> Vector{F64Sec}

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

Corresponds to BIDS "SliceTiming".
"""
slice_timing(x) = getter(x, :slice_timing, Vector{F64Sec}, i -> F64Sec[])
slice_timing!(x, val) = setter!(x, :slice_timing, Vector{F64Sec}, val)

"""
    software_versions(x) -> String

The manufacturer’s designation of software version of the equipment
that produced the composite instances.

Corresponds to BIDS "SoftwareVersions".
"""
software_versions(x) = getter(x, :software_versions, String, i -> "")
software_versions!(x, val) = setter!(x, :software_versions, String, val)

"""
    start_time(x) -> F64Sec

Start time in seconds in relation to the start of acquisition of the first data
sample in the corresponding neural dataset (negative values are allowed).

Corresponds to BIDS "StartTime".
"""
start_time(x) = first(timaxis(x))

"""
    station_name(x) -> String

Institution defined name of the machine that produced the composite instances.

Corresponds to BIDS "StationName".
"""
station_name(x) = getter(x, :station_name, String, i -> "")
station_name!(x, val) = setter!(x, :station_name, String, val)

"""
    subject_artefact_description(x) -> String

Freeform description of the observed subject artefact and its possible cause (e.g.,
"door open", "nurse walked into room at 2 min", "seizure at 10 min"). If this
field is left empty, it will be interpreted as absence of artifacts.

Corresponds to BIDS "SubjectArtefactDescription".
"""
subject_artefact_description(x) = getter(x, :subject_artefact_description, String, i -> "")
subject_artefact_description!(x, val) = setter!(x, :subject_artefact_description, String, val)

"""
    task_description(x) -> String

Longer description of the task.

Corresponds to BIDS "TaskDescription".
"""
task_description(x) = getter(x, :task_description, String, i -> "")
task_description!(x, val) = setter!(x, :task_description, String, val)

"""
    task_name(x) -> String

Name of the task. No two tasks should have the same name. Task label (task-) included
in the file name is derived from this field by removing all non alphanumeric
([a-zA-Z0-9]) characters. For example task name faces n-back will corresponds to
task label facesnback. A RECOMMENDED convention is to name resting state task using
labels beginning with rest.

Corresponds to BIDS "TaskName".
"""
task_name(x) = getter(x, :task_name, String, i -> "")
task_name!(x, val) = setter!(x, :task_name, String, val)

"""
    total_readout_time(x) -> F64Sec

The total readout time. This is actually the "effective" total readout time ,
defined as the readout duration, specified in seconds, that would have generated
data with the given level of distortion. It is NOT the actual, physical duration
of the readout train. If `effective_echo_spacing` has been properly computed, it
is just `effective_echo_spacing * (ReconMatrixPE - 1)`.<sup>3</sup> .

* This parameter is
REQUIRED if corresponding "field/distortion" maps acquired with opposing phase
encoding directions are present.

<sup>3</sup>We use the "FSL definition", i.e, the time between the center of the
first "effective" echo and the center of the last "effective" echo.

Corresponds to BIDS "TotalReadoutTime".
"""
total_readout_time(x) = getter(x, :total_readout_time, F64Sec, i -> 1.0u"s")
total_readout_time!(x, val) = setter!(x, :total_readout_time, F64Sec, val)

"""
    volume_timing(x) -> Vector{F64Sec}

Returns the time at which each volume was acquired during the acquisition. It is
described using a list of times (in JSON format) referring to the onset of each
volume in the BOLD series. The list must have the same length as the BOLD
series, and the values must be non-negative and monotonically increasing. This
field is mutually exclusive with repetition_time and delay_time. If defined, this
requires acquisition time (TA) be defined via either slice_timing or
acquisition_duration be defined.

Corresponds to BIDS "VolumeTiming".
"""
volume_timing(x) = getter(x, :volume_timing, Vector{F64Sec}, i -> F64Sec[])
volume_timing!(x, val) = setter!(x, :volume_timing, Vector{F64Sec}, val)
