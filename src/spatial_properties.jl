const PROPERTIES = [
    :stream_offset,
    :auxfiles,
    :srcfile,
    :calmax,
    :calmin
    :freqdim,
    :phasedim,
    :slicedim,
    :slice_start,
    :slice_duration,

    :AcquisitionDuration,
    :AnatomicalLandmarkCoordinates,
    :AnatomicalLandmarkCoordinateSystem,
    :AnatomicalLandmarkCoordinateUnits,
    :AnatomicalLandmarkCoordinateSystemDescription,
    :CogAtlasID,
    :CogPOID,
    :CoilCombinationMethod,
    :ContrastBolusIngredient,
    :DelayAfterTrigger,
    :DelayTime,
    :DeviceSerialNumber,
    :DewarPosition,
    :DwellTime,
    :EchoTime,
    :EffectiveEchoSpacing,
    :EEGGround,
    :EEGPlacementScheme,
    :ElectricalStimulation,
    :EpochLength,
    :FiducialDescription,
    :FlipAngle,
    :GradientSetType,
    :HeadCoilCoordinates,
    :HeadCoilCoordinateSystem,
    :HeadCoilCoordinateSystemDescription,
    :HeadCoilCoordinateUnits,
    :InstitutionName,
    :InstitutionAddress,
    :InstitutionalDepartmentName,
    :Instructions,
    :IntendedFor,
    :InversionTime,
    :MagneticFieldStrength,
    :Manufacturer,
    :Manufacturer_model_name,
    :MatrixCoilMode,
    :MRTransmitCoilSequence,
    :MultibandAccelerationFactor,
    :NegativeContrast,
    :NumberOfVolumesDiscardedByScanner,
    :NumberOfVolumesDiscardedByUser,
    :NumberShots,
    :NonlinearGradientCorrection,
    :ParallelAcquisitionTechnique,
    :ParallelReductionFactor,
    :PartialFourier,
    :PartialFourierDirection,
    :PhaseEncodingDirection,
    :PowerLineFrequency,
    :PulseSequence,
    :PulseSequenceDetails,
    :PulseSequenceType,
    :ReceiveCoilActiveElements,
    :ReceiveCoilName,
    :RecordingDuration,
    :RecordingType,
    :RepetitionTime,
    :SamplingFrequency,
    :ScanOptions,
    :ScanningSequence,
    :SequenceName,
    :SequenceVarient,
    :SubjectArtefactDescription,
    :SliceEncodingDirection,
    :SliceTiming,
    :SoftwareVersions,
    :StationName,
    :TaskDescription,
    :TotalReadoutTime,
    :VolumeTiming,
   ]

NO_SET_PROPERTIES = [:AnatomicalLandmarkCoordinateSystem,
                     :AnatomicalLandmarkCoordinateUnits,
                     :HeadCoilCoordinateSystem,
                     :HeadCoilCoordinateUnits]

"""
    spatial_offset(img)

Provides the offset of each dimension (i.e., where each spatial axis starts).
"""
spatial_offset(x) = first.(coords_indices(x))

"""
    spatial_units(img)

Returns the units (i.e. Unitful.unit) that each spatial axis is measured in. If not
available `nothing` is returned for each spatial axis.
"""
spatial_units(x) = unit.(eltype.(spatial_indices(x)))

"""
    freqdim(x) -> Int

Which spatial dimension (1, 2, or 3) corresponds to phase acquisition. If not
applicable to scan type defaults to `0`.
"""
freqdim(x) = getter(x, :freqdim, Int, 0)
freqdim!(x, val) = setter!(x, :freqdim, Int, val)

"""
    slicedim(x) -> Int

Which dimension slices where acquired at throughout MRI acquisition.
"""
slicedim(x) = getter(x, :slicedim, Int, i -> 0)
slicedim!(x, val) = setter!(x, :slicedim, Int, val)

"""
    phasedim(x) -> Int

Which spatial dimension (1, 2, or 3) corresponds to phase acquisition.
"""
phasedim(x) = getter(x, :phasedim, Int, i -> 0)
phasedim!(x, val) = setter!(x, :phasedim, Int, val)

"""
    slice_start(x) -> Int

Which slice corresponds to the first slice acquired during MRI acquisition
(i.e. not padded slices). Defaults to `1`.
"""
slice_start(x) = getter(x, :slice_start, Int, i -> 1)
slice_start!(x, val) = setter!(x, :slice_start, Int, val)

"""
    slice_end(x) -> Int

Which slice corresponds to the last slice acquired during MRI acquisition
(i.e. not padded slices).
"""
slice_end(x) = getter(x, :slice_end, Int, i -> 1)
slice_end!(x, val) = setter!(x, :slice_end, Int, val)

"""
    slice_duration(x) -> F64Sec

The amount of time necessary to acquire each slice throughout the MRI
acquisition.
"""
slice_duration(x) = getter(x, :slice_duration, F64Sec, i -> 1.0u"s")
slice_duration!(x, val) = setter!(x, :slice_duration, F64Sec, val)
