# Imaging Metadata

## Sequence Metadata

```@docs
NeuroCore.SequenceMetadata
```

### Properties

```@docs
NeuroCore.nonlinear_gradient_correction
NeuroCore.pulse_sequence
NeuroCore.pulse_sequence_details
NeuroCore.scanning_sequence
NeuroCore.sequence_name
NeuroCore.sequence_variant
```

## Encoding Direction

```@docs
NeuroCore.EncodingDirectionMetadata
```

### Properties

```@docs
NeuroCore.EncodingDirection
NeuroCore.phase_encoding_direction
NeuroCore.slice_encoding_direction
NeuroCore.freqdim
NeuroCore.phasedim
NeuroCore.slicedim
NeuroCore.slice_start
NeuroCore.slice_end
NeuroCore.slice_duration
```

## Spatial Encoding

### Properties

```@docs
NeuroCore.nshots
NeuroCore.effective_echo_spacing
NeuroCore.parallel_acquisition_technique
NeuroCore.parallel_reduction_factor_in_plane
NeuroCore.partial_fourier
NeuroCore.partial_fourier_direction
NeuroCore.total_readout_time
```

## Magentization Transfer

```@docs
NeuroCore.MagnetizationTransferMetadata
```

### Properties
```@docs
NeuroCore.mt_state
NeuroCore.mt_offset_frequency
NeuroCore.mt_pulse_bandwidth
NeuroCore.mt_npulses
NeuroCore.mt_pulse_shape
NeuroCore.mt_pulse_duration
```

## Spoiling

```@docs
NeuroCore.SpoilingMetadata
```

### Properties

```@docs
NeuroCore.spoiling_state
NeuroCore.spoiling_type
NeuroCore.spoiling_gradient_moment
NeuroCore.spoiling_gradient_duration
```

## Time

```@docs
NeuroCore.echo_time
NeuroCore.inversion_time
NeuroCore.slice_timing
NeuroCore.dwell_time
NeuroCore.delay_time
NeuroCore.acquisition_duration
NeuroCore.volume_timing
NeuroCore.repetition_time
```
