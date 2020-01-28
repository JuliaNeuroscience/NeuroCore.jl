"""
The coil combination method used for image acquisiton. Almost all fMRI studies
using phased-array coils use root-sum-of-squares (rSOS) combination, but other
methods exist. The image reconstruction is changed by the coil combination method
(as for the matrix coil mode above), so anything non-standard should be reported.
"""
@defprop CoilCombinationMethod{:coil_combination_method}::String

"""
The gradient set type. It should be possible to infer the gradient coil from the
scanner model. If not, e.g. because of a custom upgrade or use of a gradient insert
set, then the specifications of the actual gradient coil should be reported independently.
"""
@defprop GradientSetType{:gradient_set_type}::String

"The nominal field strength of MR magnet in Tesla."
@defprop MagneticFieldStrength{:magnetic_field_strength}::(x -> tesla_type(x))

"""
Returns the matrix coil mode. A method for reducing the number of independent
channels by combining in analog the signals from multiple coil elements. There
are typically different default modes when using un-accelerated or accelerated
(e.g. GRAPPA, SENSE) imaging.
"""
@defprop MatrixCoilMode{:matrix_coil_mode}::String

"""
A sequence that provides information about the transmit coil used. This is a relevant
field if a non-standard transmit coil is used.
"""
@defprop MRTransmitCoilSequence{:mr_transmit_coil_sequence}::String

"""
The information describing the receiver coil. Corresponds to DICOM Tag
Receive Coil Name, although not all vendors populate that DICOM Tag, in which
case this field can be derived from an appropriate private DICOM field.
"""
@defprop ReceiveCoilName{:receive_coil_name}::String

"""
Information describing the active/selected elements of the receiver coil. This
doesn’t correspond to a tag in the DICOM ontology. The vendor-defined terminology
for active coil elements can go in this field. As an example, for
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
@defprop ReceiveCoilActiveElements{:receive_coil_active_elements}::String

"Returns the flip angle for the acquisition in degrees."
@defprop FlipAngle{:flip_angle}::(x -> degree_type(x))

"Returns the multiband factor, for multiband acquisitions."
@defprop MultibandAccelerationFactor{:multiband_acceleration_factor}::String

"""
Specifies whether increasing voxel intensity (within sample voxels)
denotes a decreased value with respect to the contrast suffix. This is commonly
the case when Cerebral Blood Volume is estimated via usage of a contrast agent
in conjunction with a T2* weighted acquisition protocol.
"""
@defprop NegativeContrast{:negative_contrast}::Bool

"Return active ingredient of constrast agent. See [`ContrastIngrediant`](@ref) for more details."
@defprop ContrastBolusIngredient{:contrast_bolus_ingredient}::ContrastIngrediant

"""
The number of volumes ("dummy scans") discarded by the scanner (as opposed
to those discarded by the user post hoc) before saving the imaging file. For example,
a sequence that automatically discards the first 4 volumes before saving would
have this field as 4. A sequence that doesn't discard dummy scans would have
this set to 0. Please note that the onsets recorded in the _event.tsv file
should always refer to the beginning of the acquisition of the first volume in
the corresponding imaging file - independent of the value of
number_of_volumes_discarded_by_scanner field.
"""
@defprop NumberOfVolumesDiscardedByScanner{:nvol_discarded_by_scanner}::Int

"""
Returns the  number of volumes ("dummy scans") discarded by the user before
including the file in the dataset. If possible, including all of the volumes is
strongly recommended. Please note that the onsets recorded in the _event.tsv file
should always refer to the beginning of the acquisition of the first volume in
the corresponding imaging file - independent of the value of
number_of_volumes_discarded_by_user field.
"""
@defprop NumberOfVolumesDiscardedByUser{:nvol_discarded_by_user}::Int
