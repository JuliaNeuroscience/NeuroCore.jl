const PROPERTIES = [
    :stream_offset,
    :auxfiles,
    :srcfile,
    :calmax,
    :calmin,
    :freqdim,
    :phasedim,
    :slicedim,
    :slice_start,

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

eget = """
    if s === :description
        return description(x)
    """
for p in PROPERTIES
    global eget = eget * """
        elseif s === :$(p)
            return $(p)(x)
        """
end

eget = eget * """
    else
        return getindex(x, s)
    end
    """

@eval begin
    function neuroproperty(x, s::Symbol)
        Base.@_inline_meta
        $eget
    end
end

###
eset = """
    if s === :description
        return description!(x, val)
    """
for p in PROPERTIES
    if p in NO_SET_PROPERTIES
        continue
    else
        global eset = eset * """
            elseif s === :$(p)
                return $(p)!(x, val)
            """
    end
end

eset = eset * """
    else
        return setindex!(x, val, s)
    end
    """

@eval begin
    function neuroproperty!(x, s::Symbol, val)
        Base.@_inline_meta
        $eset
    end
end
