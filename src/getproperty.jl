const PROPERTIES = [
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
    :ElectricalStimulationParameters,
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
    :ManufacturerModelName,
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

function generate_getproperty(props)
    e = :(return getindex(properties(x),  s))
    for p in props
        e = :(if $(Expr(:call, :(===), :s, QuoteNode(p)))
              return $p(x)
          else
              $e
          end
         )
    end
    @eval begin
        function neuroproperty(x, s::Symbol)
            Base.@_inline_meta
            $e
        end
    end
    return nothing
end
generate_getproperty(PROPERTIES)

function generate_setproperty(props, noprops)
    e = :(return setindex!(properties(x), val, s))
    for p in props
        if p in noprops
            continue
        else
            pp = Symbol(p, :!)
            e = :(if $(Expr(:call, :(===), :s, QuoteNode(p)))
                  return $pp(x, val)
              else
                  $e
              end
             )
        end
    end
    @eval begin
        function neuroproperty!(x, s::Symbol, val)
            Base.@_inline_meta
            $e
        end
    end
    return nothing
end
generate_setproperty(PROPERTIES, NO_SET_PROPERTIES)
