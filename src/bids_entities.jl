"""
    AcquisitionDuration(x) -> F64Sec

Duration (in seconds) of volume acquisition. This field is REQUIRED for
sequences that are described with the VolumeTimingfield and that not have the
SliceTiming field set to allowed for accurate calculation of "acquisition time".
This field is mutually exclusive with RepetitionTime.
"""
AcquisitionDuration(x) = getter(x, :AcquisitionDuration, F64Sec, i -> 1.0u"s")
AcquisitionDuration!(x, val) = setter!(x, :AcquisitionDuration, F64Sec, val)

"""
    AnatomicalLandmarkCoordinates(x) -> Dict{String,NTuple{3,Float64}}

Key:value pairs of any number of additional anatomical landmarks and their coordinates
in voxel units (where first voxel has index 0,0,0) relative to the associated anatomical
MRI, (e.g. Dict("AC" => (127.0,119.0,149.0), "PC"=> (128.0,93.0,141.0),
"IH"=> (131.0114.0,206.0)).
"""
AnatomicalLandmarkCoordinates(x) = getter(x, :AnatomicalLandmarkCoordinates, Dict{String,NTuple{3,Float64}}, i -> Dict{String,NTuple{3,Float64}}())
AnatomicalLandmarkCoordinates!(x, val) = setter!(x, :AnatomicalLandmarkCoordinates, Dict{String,NTuple{3,Float64}}, val)

"""
    AnatomicalLandmarkCoordinateSystem(x)

Defines the coordinate system for the anatomical landmarks. See [`CoordinateSystem`](@ref).
"""
AnatomicalLandmarkCoordinateSystem(x) = coordinate_system(x)

"""
    AnatomicalLandmarkCoordinateUnits(x)

Units of the coordinates of AnatomicalLandmarkCoordinateSystem. MUST be m, cm, or mm.
"""
AnatomicalLandmarkCoordinateUnits(x) = spatial_units(x)

"""
AnatomicalLandmarkCoordinateSystemDescription

Freeform text description or link to document describing the anatomical coordinate
system detail.
"""
AnatomicalLandmarkCoordinateSystemDescription(x) = getter(x, :AnatomicalLandmarkCoordinateSystemDescription, String, i -> "")
AnatomicalLandmarkCoordinateSystemDescription!(x, val) = setter!(x, :AnatomicalLandmarkCoordinateSystemDescription, String, val)

"""
    CoilCombinationMethod(x) -> String

Returns the coil combination method.

Almost all fMRI studies using phased-array coils use root-sum-of-squares (rSOS)
combination, but other methods exist. The image reconstruction is changed by
the coil combination method (as for the matrix coil mode above), so anything
non-standard should be reported.
"""
CoilCombinationMethod(x) =  getter(x, :CoilCombinationMethod, String, i -> "")
CoilCombinationMethod!(x, val) =  getter(x, :CoilCombinationMethod, String, val)

"""
    CogAtlasID(x) -> String

URL of the corresponding [Cognitive Atlas Task](https://www.cognitiveatlas.org/) term.
"""
CogAtlasID(x) =  getter(x, :CogAtlasID, String, i -> "")
CogAtlasID!(x, val) =  getter(x, :CogAtlasID, String, val)

"""
    CogPOID(x) -> String

URL of the corresponding [CogPO](http://www.cogpo.org/) term.
"""
CogPOID(x) =  getter(x, :CogPOID, String, i -> "")
CogPOID!(x, val) =  getter(x, :CogPOID, String, val)

"""
    ContrastBolusIngredient(x) -> String

Return active ingredient of constrast agent. Values MUST be one of: IODINE,
GADOLINIUM, CARBON DIOXIDE, BARIUM, XENON.
"""
ContrastBolusIngredient(x) = getter(x, :ContrastBolusIngredient, String, i -> "")
ContrastBolusIngredient!(x, val) = setter!(x, :ContrastBolusIngredient, String, val)

"""
    DelayTime(x) -> F64Sec

Returns the user specified time (in seconds) to delay the acquisition of data for
the following volume. If the field is not present it is assumed to be set to zero.
Corresponds to Siemens CSA header field lDelayTimeInTR. This field is REQUIRED
for sparse sequences using the RepetitionTime field that do not have the
SliceTiming field set to allowed for accurate calculation of "acquisition time".
This field is mutually exclusive with VolumeTiming.
"""
DelayTime(x) = getter(x, :DelayTime, F64Sec, i -> 1.0u"s")
DelayTime!(x, val) = setter!(x, :DelayTime, F64Sec, val)

"""
    DelayAfterTrigger(x) -> F64Sec

Returns duration (in seconds) from trigger delivery to scan onset. This delay is
commonly caused by adjustments and loading times. This specification is entirely
independent of NumberOfVolumesDiscardedByScanner or NumberOfVolumesDiscardedByUser,
as the delay precedes the acquisition.
"""
DelayAfterTrigger(x) = getter(x, :DelayAfterTrigger, F64Sec, i -> 1.0u"s")
DelayAfterTrigger!(x, val) = setter!(x, :DelayAfterTrigger, F64Sec, val)

"""
    DeviceSerialNumber(x) -> String

The serial number of the equipment that produced the composite instances.
A pseudonym can also be used to prevent the equipment from being identifiable,
so long as each pseudonym is unique within the dataset.
"""
DeviceSerialNumber(x) = getter(x, :DeviceSerialNumber, String, i -> "00000")
DeviceSerialNumber!(x, val) = setter!(x, :DeviceSerialNumber, String, val)

"""
    DewarPosition(x)

Position of the dewar during the MEG scan: upright, supine or degrees of angle
from vertical: for example on CTF systems, upright=15°, supine = 90°.
"""
DewarPosition(x) = getter(x, :DewarPosition, IntDeg, i -> OneIntDeg)
DewarPosition!(x, val) = setter!(x, :DewarPosition, IntDeg, val)

"""
    DwellTime(x) -> F64Sec

Actual dwell time (in seconds) of the receiver per point in the readout
direction, including any oversampling. For Siemens, this corresponds to DICOM
field (0019,1018) (in ns). This value is necessary for the optional readout
distortion correction of anatomicals in the HCP Pipelines. It also usefully
provides a handle on the readout bandwidth, which isn’t captured in the other
metadata tags. Not to be confused with `EffectiveEchoSpacing`, and the frequent
mislabeling of echo spacing (which is spacing in the phase encoding direction)
as "dwell time" (which is spacing in the readout direction).
"""
DwellTime(x) = getter(x, :DwellTime, F64Sec, i -> 1.0u"s")
DwellTime!(x, val) = setter!(x, :DwellTime, F64Sec, val)

"""
    EchoTime(x) -> F64Sec

Return the echo time (TE) for the acquisition.

This parameter is REQUIRED if corresponding fieldmap data is present or the
data comes from a multi echo sequence.

please note that the DICOM term is in milliseconds not seconds
"""
EchoTime(x) = getter(x, :EchoTime, F64Sec, i -> 1.0u"s")
EchoTime!(x, val) = setter!(x, :EchoTime, F64Sec, val)

"""
    EffectiveEchoSpacing(x) -> F64Sec

Returns the effective echo spacing.

The "effective" sampling interval, specified in seconds, between lines in the
phase-encoding direction, defined based on the size of the reconstructed image
in the phase direction. It is frequently, but incorrectly, referred to as
"dwell time" (see `DwellTime` parameter below for actual dwell time). It is
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
[here](https://github.com/neurolabusc/dcm_qa/tree/master/In/TotalReadoutTime)
"""
EffectiveEchoSpacing(x) = getter(x, :EffectiveEchoSpacing, F64Sec, i -> 0.0u"s")
EffectiveEchoSpacing!(x, val) = setter!(x, :EffectiveEchoSpacing, F64Sec, val)

"""
    EEGElectrodeGroups(x) -> String

Field to describe the way electrodes are grouped into strips, grids or depth probes
e.g., {'grid1': "10x8 grid on left temporal pole", 'strip2': "1x8 electrode strip on xxx"}.
"""
EEGElectrodeGroups(x) = getter(x, :EEGElectrodeGroups, String, i -> "")
EEGElectrodeGroups!(x, val) = setter!(x, :EEGElectrodeGroups, String, val)

"""
    EEGGround(x) -> String

Description of the location of the ground electrode ("placed on right mastoid (M2)").
"""
EEGGround(x) = getter(x, :EEGGround, String, i -> "")
EEGGround!(x, val) = setter!(x, :EEGGround, String, val)

"""
    EEGPlacementScheme(x)

Freeform description of the placement of the iEEG electrodes.
Left/right/bilateral/depth/surface (e.g., "left frontal grid and bilateral
hippocampal depth" or "surface strip and STN depth" or "clinical indication
bitemporal, bilateral temporal strips and left grid").
"""
EEGPlacementScheme(x) = getter(x, :EEGPlacementScheme, String, i -> "")
EEGPlacementScheme!(x, val) = setter!(x, :EEGPlacementScheme, String, val)

"""
    ElectricalStimulation(x) -> Bool

Boolean field to specify if electrical stimulation was done during the recording
(options are `true` or `false`). Parameters for event-like stimulation should be
specified in the _events.tsv file.
"""
ElectricalStimulation(x) = getter(x, :ElectricalStimulationParameters, Bool, i -> false)
ElectricalStimulation!(x, val) = setter!(x, :ElectricalStimulationParameters, Bool, val)

"""
    EpochLength(x) -> F64Sec

Duration of individual epochs in seconds (e.g., 1) in case of epoched data. If
recording was continuous or discontinuous, leave out the field.
"""
EpochLength(x) = getter(x, :EpochLength, F64Sec, OneF64Sec)
EpochLength!(x, val) = getter(x, :EpochLength, F64Sec, val)

"""
    ElectricalStimulationParameters(x) -> String

Free form description of stimulation parameters, such as frequency, shape etc.
Specific onsets can be specified in the _events.tsv file. Specific shapes can be
described here in freeform text.
"""
ElectricalStimulationParameters(x) = getter(x, :ElectricalStimulationParameters, String, i -> "")
ElectricalStimulationParameters!(x, val) = setter!(x, :ElectricalStimulationParameters, String, val)

"""
    FiducialDescription(x) -> String

A freeform text field documenting the anatomical landmarks that were used and how
the head localization coils were placed relative to these. This field can describe,
for instance, whether the true anatomical locations of the left and right pre-auricular
points were used and digitized, or rather whether they were defined as the intersection
between the tragus and the helix (the entry of the ear canal), or any other anatomical
description of selected points in the vicinity of the ears.
"""
FiducialDescription(x) = getter(x, :FiducialDescription, String, i -> "")
FiducialDescription!(x, val) = setter!(x, :FiducialDescription, String, val)

"""
    FlipAngle(x) -> Int

Returns the flip angle for the acquisition in degrees.
"""
FlipAngle(x) = getter(x, :FlipAngle, Int, i -> 0)
FlipAngle!(x, val) = setter!(x, :FlipAngle, Int, val)

"""
    GradientSetType(x) -> String

Returns the gradient set type. It should be possible to infer the gradient coil
from the scanner model. If not, e.g. because of a custom upgrade or use of a
gradient insert set, then the specifications of the actual gradient coil should
be reported independently.
"""
GradientSetType(x) = getter(x, :GradientSetType, String, i -> "")
GradientSetType!(x, val) = setter!(x, :GradientSetType, String, val)

"""
    HeadCoilCoordinates(x) -> Dict{String,NTuple{3,Float64}}

Key:value pairs describing head localization coil labels and their coordinates,
interpreted following the HeadCoilCoordinateSystem, e.g., {NAS: [12.7,21.3,13.9],
LPA: [5.2,11.3,9.6], RPA: [20.2,11.3,9.1]}. Note that coils are not always placed
at locations that have a known anatomical name (e.g. for Elekta, Yokogawa systems);
in that case generic labels can be used (e.g. {coil1: [12.2,21.3,12.3],
coil2: [6.7,12.3,8.6], coil3: [21.9,11.0,8.1]} ).
"""
HeadCoilCoordinates(x) = getter(x, :HeadCoilCoordinates, Dict{String,NTuple{3,Float64}}, i -> Dict{String,NTuple{3,Float64}}())
HeadCoilCoordinates!(x, val) = setter!(x, :HeadCoilCoordinates, Dict{String,NTuple{3,Float64}}, val)

"""
    HeadCoilCoordinateSystem(x) -> CoordinateSystem

Defines the coordinate system for the coils.
"""
HeadCoilCoordinateSystem(x) = getter(x, :HeadCoilCoordinateSystem, CoordinateSystem, i -> UnknownSpace)

"""
    HeadCoilCoordinateSystemDescription(x) -> String

Freeform text description or link to document describing the Head Coil coordinate
system system in detail.
"""
HeadCoilCoordinateSystemDescription(x) = getter(x, :HeadCoilCoordinateSystemDescription, String, i -> "")
HeadCoilCoordinateSystemDescription!(x, val) = setter!(x, :HeadCoilCoordinateSystemDescription, String, val)

"""
    HeadCoilCoordinateUnits(x) -> m, cm, or mm

Units of the coordinates of HeadCoilCoordinateSystem.
"""
HeadCoilCoordinateUnits(x) = spatial_units(x)

"""
    InstitutionAddress(x) -> String

Return the address of the institution in charge of the equipment that produced
the composite instances.
"""
InstitutionAddress(x) = getter(x, :InstitutionAddress, String, i -> "")
InstitutionAddress!(x, val) = setter!(x, :InstitutionAddress, String, val)

"""
    InstitutionalDepartmentName(x) -> String

Return the department in the institution in charge of the equipment that produced
the composite instances.
"""
InstitutionalDepartmentName(x) = getter(x, :InstitutionalDepartmentName, String, i -> "")
InstitutionalDepartmentName!(x, val) = setter!(x, :InstitutionalDepartmentName, String, val)

"""
    InstitutionName(x) -> String

Returns the name of the institution in charge of the equipment that produced the
composite instances.
"""
InstitutionName(x) = getter(x, :InstitutionName, String, i -> "")
InstitutionName!(x, val) = setter!(x, :InstitutionName, String, val)

"""
    Instructions(x) -> String

Text of the instructions given to participants before the scan. This is especially
important in context of resting state fMRI and distinguishing between eyes open and
eyes closed paradigms.
"""
Instructions(x) = getter(x, :Instructions, String, i -> "")
Instructions!(x, val) = setter!(x, :Instructions, String, val)

"""
    IntendedFor(x) -> Vector{String}

Path or list of path relative to the subject subfolder pointing to the structural
MRI, possibly of different types if a list is specified, to be used with the MEG
recording. The path(s) need(s) to use forward slashes instead of backward slashes
(e.g. ses-/anat/sub-01_T1w.nii.gz).
"""
IntendedFor(x) = getter(x, :IntendedFor, Vector{String}, i -> String[])
IntendedFor!(x, val) = setter!(x, :IntendedFor, Vector{String}, val)

"""
    InversionTime(x) -> F64Sec

Returns the inversion time (TI) for the acquisition, specified in seconds.
Inversion time is the time after the middle of inverting RF pulse to middle of
excitation pulse to detect the amount of longitudinal magnetization.
"""
InversionTime(x) = getter(x, :InversionTime, F64Sec, i -> 1.0u"s")
InversionTime!(x, val) = setter!(x, :InversionTime, F64Sec, val)

"""
    MagneticFieldStrength(x) -> F64Tesla

The nominal field strength of MR magnet in Tesla.
"""
MagneticFieldStrength(x) = getter(x, :MagneticFieldStrength, F64Tesla, i -> 3.0u"T")
MagneticFieldStrength!(x, val) = setter!(x, :MagneticFieldStrength, F64Tesla, val)

"""
    Manufacturer(x) -> String

The Manufacturer of the equipment that produced the composite instances.
"""
Manufacturer(x) = getter(x, :Manufacturer, String, i -> "")
Manufacturer!(x, val) = setter!(x, :Manufacturer, String, val)

"""
    ManufacturerModelName(x) -> String

The Manufacturer's model name of the equipment that produced the composite instances.
"""
ManufacturerModelName(x) = getter(x, :ManufacturerModelName, String, i -> "")
ManufacturerModelName!(x, val) = setter!(x, :ManufacturerModelName, String, val)

"""
    MatrixCoilMode(x) -> String

Returns the matrix coil mode. A method for reducing the number of independent
channels by combining in analog the signals from multiple coil elements. There
are typically different default modes when using un-accelerated or accelerated
(e.g. GRAPPA, SENSE) imaging.
"""
MatrixCoilMode(x) = getter(x, :MatrixCoilMode, String, i -> "")
MatrixCoilMode!(x, val) = setter!(x, :MatrixCoilMode, String, val)

"""
    MRTransmitCoilSequence(x) -> String

A sequence that provides information about the transmit coil used. This is a
relevant field if a non-standard transmit coil is used.
"""
MRTransmitCoilSequence(x) = getter(x, :MRTransmitCoilSequence, String, i -> "")
MRTransmitCoilSequence!(x, val) = setter!(x, :MRTransmitCoilSequence, String, val)

"""
    MultibandAccelerationFactor(x) -> String

Returns the multiband factor, for multiband acquisitions.
"""
MultibandAccelerationFactor(x) = getter(x, :MultibandAccelerationFactor, String, i -> "")
MultibandAccelerationFactor!(x, val) = setter!(x, :MultibandAccelerationFactor, String, val)

"""
    NegativeContrast(x) -> Bool

Specifies whether increasing voxel intensity (within sample voxels)
denotes a decreased value with respect to the contrast suffix. This is commonly
the case when Cerebral Blood Volume is estimated via usage of a contrast agent
in conjunction with a T2* weighted acquisition protocol.
"""
NegativeContrast(x) = getter(x, :NegativeContrast, Bool, i -> false)
NegativeContrast!(x, val) = setter!(x, :NegativeContrast, Bool, val)

"""
    NonlinearGradientCorrection(x) -> Bool

Returns `Bool` stating if the image saved has been corrected for gradient
nonlinearities by the scanner sequence. Default is `false`.
"""
NonlinearGradientCorrection(x) = getter(x, :NonlinearGradientCorrection, Bool, i -> false)
NonlinearGradientCorrection!(x, val) = setter!(x, :NonlinearGradientCorrection, Bool, val)

"""
    NumberOfVolumesDiscardedByScanner(x) -> Int

Returns the number of volumes ("dummy scans") discarded by the scanner (as opposed
to those discarded by the user post hoc) before saving the imaging file. For example,
a sequence that automatically discards the first 4 volumes before saving would
have this field as 4. A sequence that doesn't discard dummy scans would have
this set to 0. Please note that the onsets recorded in the _event.tsv file
should always refer to the beginning of the acquisition of the first volume in
the corresponding imaging file - independent of the value of
NumberOfVolumesDiscardedByScanner field.
"""
NumberOfVolumesDiscardedByScanner(x) = getter(x, :NumberOfVolumesDiscardedByScanner, Int, i -> 0)
NumberOfVolumesDiscardedByScanner!(x, val) = setter!(x, :NumberOfVolumesDiscardedByScanner, Int, val)

"""
    NumberOfVolumesDiscardedByUser(x) -> Int

Returns the  number of volumes ("dummy scans") discarded by the user before
including the file in the dataset. If possible, including all of the volumes is
strongly recommended. Please note that the onsets recorded in the _event.tsv file
should always refer to the beginning of the acquisition of the first volume in
the corresponding imaging file - independent of the value of
NumberOfVolumesDiscardedByUser field.
"""
NumberOfVolumesDiscardedByUser(x) = getter(x, :NumberOfVolumesDiscardedByUser, Int, i -> 0)
NumberOfVolumesDiscardedByUser!(x, val) = setter!(x, :NumberOfVolumesDiscardedByUser, Int, val)

"""
    NumberShots(x) -> Int

Returns the number of RF excitations needed to reconstruct a slice or volume.
Please mind that this is not the same as Echo Train Length which denotes the
number of lines of k-space collected after an excitation.
"""
NumberShots(x) = getter(x, :NumberShots, Int, i -> 0)
NumberShots!(x, val) = setter!(x,  :NumberShots, Int, val)

"""
    ParallelAcquisitionTechnique(x) -> String

Returns the type of parallel imaging used (e.g. GRAPPA, SENSE).
"""
ParallelAcquisitionTechnique(x) = getter(x, :ParallelAcquisitionTechnique, String, i -> "")
ParallelAcquisitionTechnique!(x, val) = setter!(x, :ParallelAcquisitionTechnique, String, val)

"""
    ParallelReductionFactor(x) -> Int

The parallel imaging (e.g, GRAPPA) factor. Use the denominator of the fraction
of k-space encoded for each slice. For example, 2 means half of k-space is
encoded.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
"""
ParallelReductionFactor(x) = getter(x, :ParallelReductionFactor, Int, i -> 0)
ParallelReductionFactor!(x, val) = setter!(x, :ParallelReductionFactor, Int, val)

"""
    PartialFourier(x) -> Float64

Returns the fraction of partial Fourier information collected.
"""
PartialFourier(x) = getter(x, :PartialFourier, Float64, i -> 1.0)
PartialFourier!(x, val) = setter!(x, :PartialFourier, Float64, val)

"""
    PartialFourierDirection(x) -> String

Returns the direction where only partial Fourier information was collected.
"""
PartialFourierDirection(x) = getter(x, :PartialFourierDirection, String, i -> "")
PartialFourierDirection!(x, val) = setter!(x, :PartialFourierDirection, String, val)

"""
    PhaseEncodingDirection(x) -> String

Returns the phase encoding direction.

Possible values: `i`, `j`, `k`, `i-`, `j-`, `k-`. The letters `i`, `j`, `k`
correspond to the first, second and third axis of the data in the NIFTI file.
The polarity of the phase encoding is assumed to go from zero index to maximum
index unless `-` sign is present (then the order is reversed - starting from
the highest index instead of zero). `PhaseEncodingDirection` is defined as the
direction along which phase is was modulated which may result in visible
distortions. Note that this is not the same as the DICOM term
`InPlanePhaseEncodingDirectiong` which can have `ROW` or `COL` values. This
parameter is REQUIRED if corresponding fieldmap data is present or when using
multiple runs with different phase encoding directions (which can be later used
for field inhomogeneity correction).
"""
PhaseEncodingDirection(x) = getter(x, :PhaseEncodingDirection, String, i -> "")
PhaseEncodingDirection!(x, val) = setter!(x, :PhaseEncodingDirection, String, val)

"""
    PowerLineFrequency(x) -> F64Hz

Frequency (in Hz) of the power grid at the geographical location of the EEG
instrument (i.e., 50 or 60).
"""
PowerLineFrequency(x) = getter(x, :PowerLineFrequency, F64Hz, i -> 1.0u"Hz")
PowerLineFrequency!(x, val) = setter!(x, :PowerLineFrequency, F64Hz, val)

"""
    PulseSequence(x) -> String

General description of the pulse sequence used for the scan (i.e. MPRAGE,
Gradient Echo EPI, Spin Echo EPI, Multiband gradient echo EPI).
"""
PulseSequence(x) = getter(x, :PulseSequence, String, i -> "")
PulseSequence!(x, val) = setter!(x, :PulseSequence, String, val)

"""
    PulseSequenceDetails(x) -> String

Information beyond pulse sequence type that identifies the specific pulse
sequence used (i.e. "Standard Siemens Sequence distributed with the VB17
software," "Siemens WIP ### version #.##," or "Sequence written by X using a
version compiled on MM/DD/YYYY").
"""
PulseSequenceDetails(x) = getter(x, :PulseSequenceDetails, String, i -> "")
PulseSequenceDetails!(x, val) = setter!(x, :PulseSequenceDetails, String, val)

"""
    PulseSequenceType(x) -> String

A general description of the pulse sequence used for the scan (i.e. MPRAGE,
Gradient Echo EPI, Spin Echo EPI, Multiband gradient echo EPI).
"""
PulseSequenceType(x) = getter(x, :PulseSequenceType, String, i -> "")
PulseSequenceType!(x, val) = setter!(x, :PulseSequenceType, String, val)

"""
    ReceiveCoilName(x) -> String

The information describing the receiver coil. Corresponds to DICOM Tag
Receive Coil Name, although not all vendors populate that DICOM Tag, in which
case this field can be derived from an appropriate private DICOM field.
"""
ReceiveCoilName(x) = getter(x, :ReceiveCoilName, String, i -> "")
ReceiveCoilName!(x, val) = setter!(x, :ReceiveCoilName, String, val)

"""
    ReceiveCoilActiveElements(x) -> String

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
"""
ReceiveCoilActiveElements(x) = getter(x, :ReceiveCoilActiveElements, String, i -> "")
ReceiveCoilActiveElements!(x, val) = setter!(x, :ReceiveCoilActiveElements, String, val)

"""
    RecordingDuration(x) -> F64Sec

Length of the recording in seconds (e.g., 3600)
"""
RecordingDuration(x) = getter(x, :RecordingDuration, F64Sec, OneF64Sec)
RecordingDuration!(x, val) = setter!(x, :RecordingDuration, F64Sec, val)

# TODO: should this return and enumerable
"""
    RecordingType(x) -> String

Defines whether the recording is "continuous", "discontinuous" or "epoched";
this latter limited to time windows about events of interest (e.g., stimulus
presentations, subject responses etc.)
"""
RecordingType(x) = getter(x, :RecordingType, String, i -> "")
RecordingType!(x, val) = setter!(x, :RecordingType, String, val)

"""
    RepetitionTime(x) -> F64Sec

Returns the time in seconds between the beginning of an acquisition of one volume
and the beginning of acquisition of the volume following it (TR). Please note that
this definition includes time between scans (when no data has been acquired) in
case of sparse acquisition schemes. This value needs to be consistent with the
pixdim[4] field (after accounting for units stored in xyzt_units field) in the
NIfTI header. This field is mutually exclusive with VolumeTiming and is derived
from DICOM Tag 0018, 0080 and converted to seconds.
"""
RepetitionTime(x) = getter(x, :RepetitionTime, F64Sec, i -> 1.0u"s")
RepetitionTime!(x, val) = setter!(x, :RepititionTime, F64Sec, val)

"""
    SamplingFrequency -> F64Hz

Sampling frequency (in Hz) of all the data in the recording, regardless of their
type (e.g., 2400).
"""
SamplingFrequency(x) = getter(x, :SamplingFrequency, F64Hz, i -> 1.0u"Hz")
SamplingFrequency!(x, val) = setter!(x, :SamplingFrequency, F64Hz, val)

"""
    ScanOptions(x)

Parameters of ScanningSequence. Corresponds to DICOM  `Scan Options`.
"""
ScanOptions(x) = getter(x, :ScanOptions, Any, i -> Dict{String,Any}())
ScanOptions!(x, val) = setter!(x, :ScanOptions, Any, val)

# TODO enumerable for bolus ingredient
"""
    ScanningSequence(x) -> String

Returns the description of the type of sequence data acquired.
"""
ScanningSequence(x) = getter(x, :ScanningSequence, String, i -> "")
ScanningSequence!(x, val) = setter!(x, :ScanningSequence, String, val)

"""
    SequenceName(x) -> String

Returns the manufacturer’s designation of the sequence name.
"""
SequenceName(x) = getter(x, :SequenceName, String, i -> "")
SequenceName!(x, val) = setter!(x, :SequenceName, String, val)

"""
    SequenceVarient(x) -> String

Returns the variant of the `ScanningSequence` property.
"""
SequenceVarient(x) = getter(x, :SequenceVarient, String, i -> "")
SequenceVarient!(x, val) = setter!(x, :SequenceVarient, String, val)

"""
    SliceEncodingDirection(x) -> String

Possible values: i, j, k, i-, j-, k- (the axis of the NIfTI data along which
slices were acquired, and the direction in which SliceTiming is defined with
respect to). i, j, k identifiers correspond to the first, second and third axis
of the data in the NIfTI file. A - sign indicates that the contents of
SliceTiming are defined in reverse order - that is, the first entry corresponds
to the slice with the largest index, and the final entry corresponds to slice
index zero. When present, the axis defined by SliceEncodingDirection needs to be
consistent with the ‘slice_dim’ field in the NIfTI header. When absent, the
entries in SliceTiming must be in the order of increasing slice index as defined
by the NIfTI header.
"""
SliceEncodingDirection(x) = getter(x, :SliceEncodingDirection, String, i -> "")
SliceEncodingDirection!(x, val) = setter!(x, :SliceEncodingDirection, String, val)

"""
    SliceTiming(x) -> Vector{F64Sec}

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
`DelayTime` field set. In addition without this parameter slice time correction
will not be possible.
"""
SliceTiming(x) = getter(x, :SliceTiming, Vector{F64Sec}, i -> F64Sec[])
SliceTiming!(x, val) = setter!(x, :SliceTiming, Vector{F64Sec}, val)

"""
    SoftwareVersions(x) -> String

The manufacturer’s designation of software version of the equipment
that produced the composite instances.
"""
SoftwareVersions(x) = getter(x, :SoftwareVersions, String, i -> "")
SoftwareVersions!(x, val) = setter!(x, :SoftwareVersions, String, val)

"""
    StationName(x) -> String

Returns the institution defined name of the machine that produced the composite instances.
"""
StationName(x) = getter(x, :StationName, String, i -> "")
StationName!(x, val) = setter!(x, :StationName, String, val)

"""
    SubjectArtefactDescription(x) -> String

Freeform description of the observed subject artefact and its possible cause (e.g.,
"door open", "nurse walked into room at 2 min", "seizure at 10 min"). If this
field is left empty, it will be interpreted as absence of artifacts.
"""
SubjectArtefactDescription(x) = getter(x, :SubjectArtefactDescription, String, i -> "")
SubjectArtefactDescription!(x, val) = setter!(x, :SubjectArtefactDescription, String, val)

"""
    TaskDescription(x) -> String

Longer description of the task.
"""
TaskDescription(x) = getter(x, :TaskDescription, String, i -> "")
TaskDescription!(x, val) = setter!(x, :TaskDescription, String, val)

"""
    TaskName(x) -> String

Name of the task. No two tasks should have the same name. Task label (task-) included
in the file name is derived from this field by removing all non alphanumeric
([a-zA-Z0-9]) characters. For example task name faces n-back will corresponds to
task label facesnback. A RECOMMENDED convention is to name resting state task using
labels beginning with rest.
"""
TaskName(x) = getter(x, :TaskName, String, i -> "")
TaskName!(x, val) = setter!(x, :TaskName, String, val)

"""
    TotalReadoutTime(x) -> F64Sec

Returns the total readout time.

This is actually the "effective" total readout time , defined as the readout
duration, specified in seconds, that would have generated data with the given
level of distortion. It is NOT the actual, physical duration of the readout
train. If `EffectiveEchoSpacing` has been properly computed, it is just
`EffectiveEchoSpacing * (ReconMatrixPE - 1)`.<sup>3</sup> .

* This parameter is
REQUIRED if corresponding "field/distortion" maps acquired with opposing phase
encoding directions are present.

<sup>3</sup>We use the "FSL definition", i.e, the time between the center of the
first "effective" echo and the center of the last "effective" echo.
"""
TotalReadoutTime(x) = getter(x, :TotalReadoutTime, F64Sec, i -> 1.0u"s")
TotalReadoutTime!(x, val) = setter!(x, :TotalReadoutTime, F64Sec, val)

"""
    VolumeTiming(x) -> Vector{F64Sec}

Returns the time at which each volume was acquired during the acquisition. It is
described using a list of times (in JSON format) referring to the onset of each
volume in the BOLD series. The list must have the same length as the BOLD
series, and the values must be non-negative and monotonically increasing. This
field is mutually exclusive with RepetitionTime and DelayTime. If defined, this
requires acquisition time (TA) be defined via either SliceTiming or
AcquisitionDuration be defined.
"""
VolumeTiming(x) = getter(x, :VolumeTiming, Vector{F64Sec}, i -> F64Sec[])
VolumeTiming!(x, val) = setter!(x, :VolumeTiming, Vector{F64Sec}, val)

