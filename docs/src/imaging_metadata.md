# Imaging Metadata

## Sequence Metadata

### Properties

```@docs
NeuroCore.NonlinearGradientCorrection
NeuroCore.PulseSequence
NeuroCore.PulseSequenceDetails
NeuroCore.PulseSequenceType
NeuroCore.ScanningSequence
NeuroCore.SequenceName
NeuroCore.SequenceVarient
```
### Metadata

```@docs
NeuroCore.SequenceMetadata
```

## Encoding Direction

```@autodocs
Modules = [NeuroCore.EncodingDirections]
Order   = [:function, :type]
```

## Spatial Encoding

### Properties

```@docs
NeuroCore.NumberShots
NeuroCore.EffectiveEchoSpacing
NeuroCore.ParallelAcquisitionTechnique
NeuroCore.ParallelReductionFactor
NeuroCore.PartialFourier
NeuroCore.PartialFourierDirection
NeuroCore.TotalReadoutTime
```

## Magentization Transfer

### Properties
```@docs
NeuroCore.MTState
NeuroCore.MTOffsetFrequency
NeuroCore.MTPulseBandwidth
NeuroCore.MTNumberOfPulses
NeuroCore.MTPulseShape
NeuroCore.MTPulseDuration
```

### Metadata

```@docs
NeuroCore.MagnetizationTransferMetadata
```

## Spoiling

### Properties

```@docs
NeuroCore.SpoilingState
NeuroCore.SpoilingType
NeuroCore.SpoilingGradientMoment
NeuroCore.SpoilingGradientDuration
```

### Metadata

```@docs
NeuroCore.SpoilingMetadata
```

## Time

```@docs
NeuroCore.EchoTime
NeuroCore.InversionTime
NeuroCore.SliceTiming
NeuroCore.DwellTime
NeuroCore.DelayTime
NeuroCore.AcquisitionDuration
NeuroCore.VolumeTiming
NeuroCore.RepetitionTime
```
