
const CLEXAMPLE = CoordinateList(:AC => (127.0,119.0,149.0), :PC=> (128.0,93.0,141.0), :IH=> (131.0114.0,206.0))

img = NeuroMetaArray(rand(4,4))
props = NeuroMetadata()

for (property, default, valin, valout) in (
    (:AcquisitionDuration, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:AnatomicalLandmarkCoordinates, CoordinateList(), CLEXAMPLE, CLEXAMPLE),
    #:AnatomicalLandmarkCoordinateSystem,
    #:AnatomicalLandmarkCoordinateUnits,
    #:AnatomicalLandmarkCoordinateSystemDescription,
    #:CogAtlasID,
    #:CogPOID,
    (:CoilCombinationMethod, "rSOS", "", ""),
    (:ContrastBolusIngredient, UnkownContrast, IODINE, IODINE),
    (:ContrastBolusIngredient, UnkownContrast, "IODINE", IODINE),
    (:DelayAfterTrigger, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:DelayTime, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:DeviceSerialNumber, "00000", "11111", "11111")A,
    (:DewarPosition, OneIntDeg, 2, 2u"°"),
    (:DwellTime, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:EchoTime, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:EffectiveEchoSpacing, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:EEGGround, "", "mastoid", "mastoid"),
    (:EEGPlacementScheme, "", "surface strip and STN depth", "surface strip and STN depth"),
    (:ElectricalStimulation, false, true, true),
    (:ElectricalStimulationParameters, "", "x", "x"),
    (:EpochLength, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:FiducialDescription, "", "pre-auricular","pre-auricular"),
    (:FlipAngle,  OneIntDeg, 2, 2u"°"),
    (:GradientSetType, "", "gradient", "gradient"),
    (:HeadCoilCoordinates, CoordinateList(), CLEXAMPLE, CLEXAMPLE),
    #:HeadCoilCoordinateSystem,
    #:HeadCoilCoordinateSystemDescription,
    #:HeadCoilCoordinateUnits,
    (:InstitutionName, "", "x", "x"),
    (:InstitutionAddress, "", "x", "x"),
    (:InstitutionalDepartmentName, "", "x", "x"),
    (:Instructions, "", "x", "x"),
    (:IntendedFor, "", "x", "x"),
    (:InversionTime, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:MagneticFieldStrength, 3.0u"T", 1.5u"T", 1.5u"T"),
    (:Manufacturer, "", "x", "x"),
    (:Manufacturer_model_name, "", "x", "x"),
    (:MatrixCoilMode, "", "x", "x"),
    (:MRTransmitCoilSequence, "", "x", "x"),
    (:MultibandAccelerationFactor, "", "x", "x"),
    (:NegativeContrast, false, true, true),
    (:NumberOfVolumesDiscardedByScanner, 0, 1, 1),
    (:NumberOfVolumesDiscardedByUser, 0, 1, 1),
    (:NumberShots, 0, 1, 1),
    (:NonlinearGradientCorrection, false, true, true),
    (:ParallelAcquisitionTechnique, "", "x", "x"),
    (:ParallelReductionFactor, 0, 1, 1),
    (:PartialFourier, 1.0, 2.0, 2.0),
    (:PartialFourierDirection, "", "x", "x"),
    (:PhaseEncodingDirection, i_direction, 2, j_direction),
    (:PowerLineFrequency, 1u"Hz", 2u"Hz", 2u"Hz"),
    (:PulseSequence, "", "x", "x"),
    (:PulseSequenceDetails, "", "x", "x"),
    (:PulseSequenceType, "", "x", "x"),
    (:ReceiveCoilActiveElements, "", "x", "x"),
    (:ReceiveCoilName, "", "x", "x"),
    (:RecordingDuration, 1u"s", 2u"s", 2u"s"),
    (:RecordingType, "", "x", "x"),
    (:RepetitionTime, 1u"s", 2u"s", 2u"s"),
    (:SamplingFrequency, 1u"Hz", 2u"Hz", 2u"Hz"),
    (:ScanOptions, "", "x", "x"),
    (:ScanningSequence, "", "x", "x"),
    (:SequenceName, "", "x", "x"),
    (:SequenceVarient, "", "x", "x"),
    (:SubjectArtefactDescription, "", "x", "x"),
    (:SliceEncodingDirection, i_direction, 2, j_direction),
    (:SliceTiming, 1u"s", 2u"s", 2u"s"),
    (:SoftwareVersions, "", "x", "x"),
    (:StationName, "", "x", "x"),
    (:TaskDescription, "", "x", "x"),
    (:TotalReadoutTime, 1u"s", 2u"s", 2u"s"),
    (:VolumeTiming, 1u"s", 2u"s", 2u"s"),
   )
    @testset "$property" begin
        @test @inferred(getproperty(img, property)) == default
        @test @inferred(getproperty(props, property)) == default
        if !in(NeuroCore.NO_SET_PROPERTIES)
            setproperty!(img, property, valin)
            setproperty!(props, property, valin)
            @test @inferred(getproperty(img, property)) == valout
            @test @inferred(getproperty(props, property)) == valout
        end
    end
end

