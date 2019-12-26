
const CLEXAMPLE = CoordinateList(:AC => (127.0, 119.0, 149.0),
                                 :PC => (128.0, 93.0, 141.0),
                                 :IH => (131.0, 114.0, 206.0))

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
    (:ContrastBolusIngredient, UnkownContrast, "IODINE", IODINE),
    (:DelayAfterTrigger, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:DelayTime, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:DeviceSerialNumber, "00000", "11111", "11111"),
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
    (:IntendedFor, String[], ["x"], ["x"]),
    (:InversionTime, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:MagneticFieldStrength, 3.0u"T", 1.5u"T", 1.5u"T"),
    (:Manufacturer, "", "x", "x"),
    (:ManufacturerModelName, "", "x", "x"),
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
    (:PartialFourierDirection, "", "COMBINATION", "COMBINATION"),
    (:PhaseEncodingDirection, ipos, 2, jpos),
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
    (:ScanOptions, Dict{Symbol,Any}(), Dict{Symbol,Any}(:randmeta => 1), Dict{Symbol,Any}(:randmeta => 1)),
    (:ScanningSequence, "", "x", "x"),
    (:SequenceName, "", "x", "x"),
    (:SequenceVarient, "", "x", "x"),
    (:SubjectArtefactDescription, "", "x", "x"),
    (:SliceEncodingDirection, ipos, 2, jpos),
    (:SliceTiming, F64Sec[], [2u"s"], [2u"s"]),
    (:SoftwareVersions, "", "x", "x"),
    (:StartTime, 1u"s", 2u"s", 2u"s"),
    (:StationName, "", "x", "x"),
    (:TaskDescription, "", "x", "x"),
    (:TotalReadoutTime, 1u"s", 2u"s", 2u"s"),
    (:VolumeTiming, F64Sec[], [2u"s"], [2u"s"]),
   )
    @testset "$property" begin
        eval(:(fxn(x) = getproperty(x, $(QuoteNode(property)))))
        eval(:(fxn!(x, val) = setproperty!(x, $(QuoteNode(property)), val)))

        @test @inferred(fxn(img)) == default
        @test @inferred(fxn(props)) == default
        if !in(property, NeuroCore.NO_SET_PROPERTIES)
            fxn!(img, valin)
            fxn!(props, valin)
            @test @inferred(fxn(img)) == valout
            @test @inferred(fxn(props)) == valout
        end
    end
end
