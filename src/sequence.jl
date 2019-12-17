"""
    pulse_sequence(x) -> String

Returns a general description of the pulse sequence used for the scan (i.e. MPRAGE,
Gradient Echo EPI, Spin Echo EPI, Multiband gradient echo EPI).
"""
pulse_sequence(x) = getter(x, "PulseSequence", String, i -> "")

"""
    pulse_sequence!(x, val)

Sets a general description of the pulse sequence used for the scan (i.e. MPRAGE,
Gradient Echo EPI, Spin Echo EPI, Multiband gradient echo EPI).
"""
pulse_sequence!(x, val) = setter!(x, "PulseSequence", String, val)

"""
    scanning_sequence(x) -> String

Returns the description of the type of sequence data acquired.
"""
scanning_sequence(x) = getter(x, "ScanningSequence", String, i -> "")

"""
    scanning_sequence!(x, val)

Sets the description of the type of sequence data acquired.
"""
scanning_sequence!(x, val) = setter!(x, "ScanningSequence", String, val)

"""
    sequence_variant(x) -> String

Returns the variant of the `scanning_sequence` property.
"""
sequence_variant(x) = getter(x, "SequenceName", String, i -> "")

"""
    sequence_variant!(x, val)

Returns the variant of the `scanning_sequence` property.
"""
sequence_variant!(x, val) = setter!(x, "SequenceName", String, val)

"""
    sequence_name(x) -> String

Returns the manufacturer’s designation of the sequence name.
"""
sequence_name(x) = getter(x, "SequenceName", String, i -> "")
"""
    sequence_name!(x, val)

Sets the manufacturer’s designation of the sequence name.
"""
sequence_name!(x, val) = setter!(x, "SequenceName", String, val)

"""
    nonlinear_gradient_correction(x) -> Bool

Returns `Bool` stating if the image saved has been corrected for gradient
nonlinearities by the scanner sequence. Default is `false`.
"""
nonlinear_gradient_correction(x) = getter(x, "NonlinearGradientCorrection", Bool, i -> false)

"""
    nonlinear_gradient_correction!(x, val)

Sets the nonlinear gradient correction state.

See also: [`nonlinear_gradient_correction`](@ref)
"""
nonlinear_gradient_correction(x, val) = setter!(x, "NonlinearGradientCorrection", Bool, val)

"""
    nvol_user_discarded(x) -> Int

Returns the  number of volumes ("dummy scans") discarded by the user before
including the file in the dataset. If possible, including all of the volumes is
strongly recommended. Please note that the onsets recorded in the _event.tsv file
should always refer to the beginning of the acquisition of the first volume in
the corresponding imaging file - independent of the value of
NumberOfVolumesDiscardedByUser field.
"""
nvol_user_discarded(x) = getter(x, "NumberOfVolumesDiscardedByUser", Int, i -> 0)

"""
    nvol_user_discarded!(x, val)

Sets the  number of volumes ("dummy scans") discarded by the user before
including the file in the dataset.

See also: [`nvol_user_discarded`](@ref)
"""
nvol_user_discarded!(x, val) = setter!(x, "NumberOfVolumesDiscardedByUser", Int, val)

"""
    nvol_scanner_discarded(x) -> Int

Returns the number of volumes ("dummy scans") discarded by the scanner (as opposed
to those discarded by the user post hoc) before saving the imaging file. For example,
a sequence that automatically discards the first 4 volumes before saving would
have this field as 4. A sequence that doesn't discard dummy scans would have
this set to 0. Please note that the onsets recorded in the _event.tsv file
should always refer to the beginning of the acquisition of the first volume in
the corresponding imaging file - independent of the value of
NumberOfVolumesDiscardedByScanner field.
"""
nvol_scanner_discarded(x) = getter(x, "NumberOfVolumesDiscardedByScanner", Int, i -> 0)

"""
    nvol_scanner_discarded!(x, val)

Sets the number of volumes ("dummy scans") discarded by the scanner (as opposed
to those discarded by the user post hoc) before saving the imaging file.

See also: [`nvol_scanner_discarded`](@ref)
"""
nvol_scanner_discarded!(x, val) = setter!(x, "NumberOfVolumesDiscardedByScanner", Int, val)

"""
    flip_angle(x) -> Int

Returns the flip angle for the acquisition in degrees.
"""
flip_angle(x) = getter(x, "FlipAngle", Int, i -> 0)

"""
    flip_angle!(x, val)

Sets the flip angle for the acquisition in degrees.
"""
flip_angle!(x, val) = setter!(x, "FlipAngle", Int, val)

"""
    multiband_acceleration_factor(x) -> String

Returns the multiband factor, for multiband acquisitions.
"""
multiband_acceleration_factor(x) = getter(x, "MultibandAccelerationFactor", String, i -> "")

"""
    multiband_acceleration_factor!(x, val)

Returns the multiband factor, for multiband acquisitions.
"""
multiband_acceleration_factor!(x, val) = setter!(x, "MultibandAccelerationFactor", String, val)

# TODO: what's the best type for this?
"""
    scan_options(x)

Parameters of ScanningSequence. Corresponds to DICOM  `Scan Options`.
"""
scan_options(x) = getter(x, "ScanOptions", Any, i -> Dict{String,Any}())

"""
    scan_options!(x, val)

Sets the parameters of ScanningSequence.
"""
scan_options!(x, val) = setter!(x, "ScanOptions", Any, val)

"""
    pulse_sequence_details(x) -> String

Returns information beyond pulse sequence type that identifies the specific pulse
sequence used (i.e. "Standard Siemens Sequence distributed with the VB17
software," "Siemens WIP ### version #.##," or "Sequence written by X using a
version compiled on MM/DD/YYYY").
"""
pulse_sequence_details(x) = getter(x, "PulseSequenceDetails", String, i -> "")

"""
    pulse_sequence_details!(x, val)

Returns information beyond pulse sequence type that identifies the specific pulse
sequence used (i.e. "Standard Siemens Sequence distributed with the VB17
software," "Siemens WIP ### version #.##," or "Sequence written by X using a
version compiled on MM/DD/YYYY").
"""
pulse_sequence_details!(x, val) = setter!(x, "PulseSequenceDetails", String, val)

"""
    negative_contrast(x) -> Bool

Returns value specifying whether increasing voxel intensity (within sample voxels)
denotes a decreased value with respect to the contrast suffix. This is commonly
the case when Cerebral Blood Volume is estimated via usage of a contrast agent
in conjunction with a T2* weighted acquisition protocol.
"""
negative_contrast(x) = getter(x, "NegativeContrast", Bool, i -> false)


"""
    negative_contrast!(x, val)

Sets the `negative_contrast` property. See [`negative_contrast`](@ref) for details.
"""
negative_contrast!(x, val) = setter!(x, "NegativeContrast", Bool, val)

"""
    contrast_bolus_ingredient(x) -> String

Return active ingredient of constrast agent. Values MUST be one of: IODINE,
GADOLINIUM, CARBON DIOXIDE, BARIUM, XENON.
"""
contrast_bolus_ingredient(x) = getter(x, "ContrastBolusIngredient", String, i -> "")

"""
    contrast_bolus_ingredient!(x, val)

Sets the active ingredient of agent. Values MUST be one of: IODINE, GADOLINIUM,
CARBON DIOXIDE, BARIUM, XENON.
"""
contrast_bolus_ingredient!(x, val) = setter!(x, "ContrastBolusIngredient", String, val)
