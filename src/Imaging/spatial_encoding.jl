"Which spatial dimension (1, 2, or 3) corresponds to phase acquisition."
@defprop FrequencyDimension{:freqdim}::Int

"Which spatial dimension (1, 2, or 3) corresponds to phase acquisition."
@defprop PhaseDimension{:phasedim}::Int

"Which slice corresponds to the first slice acquired during MRI acquisition (i.e. not padded slices)."
@defprop SliceStart{:slice_start}::Int

"Which slice corresponds to the last slice acquired during MRI acquisition (i.e. not padded slices)."
@defprop SliceEnd{:slice_end}::Int

"Which dimension slices where acquired at throughout MRI acquisition."
@defprop SliceDim{:slicedim}::Int

"""
The number of RF excitations needed to reconstruct a slice or volume.
Please mind that this is not the same as Echo Train Length which denotes the
number of lines of k-space collected after an excitation.
"""
@defprop NumberShots{:nshots}::Int

"""
The "effective" sampling interval, specified in seconds, between lines in the
phase-encoding direction, defined based on the size of the reconstructed image
in the phase direction. It is frequently, but incorrectly, referred to as
"dwell time" (see `dwell_time` parameter below for actual dwell time). It is
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
[here](https://github.com/neurolabusc/dcm_qa/tree/master/In/total_readout_time)
"""
@defprop EffectiveEchoSpacing{:effective_echo_spacing}::(x -> second_type(x))

"The type of parallel imaging used (e.g. GRAPPA, SENSE)."
@defprop ParallelAcquisitionTechnique{:parallel_acquisition_technique}::String

"""
The parallel imaging (e.g, GRAPPA) factor. Use the denominator of the fraction
of k-space encoded for each slice. For example, 2 means half of k-space is encoded.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
"""
@defprop ParallelReductionFactor{:parallel_reduction_factor_in_plane}::Int

"The fraction of partial Fourier information collected."
@defprop PartialFourier{:partial_fourier}::Float64

"The direction where only partial Fourier information was collected."
@defprop PartialFourierDirection{:partial_fourier_direction}::String

"""
The total readout time. This is actually the "effective" total readout time ,
defined as the readout duration, specified in seconds, that would have generated
data with the given level of distortion. It is NOT the actual, physical duration
of the readout train. If `effective_echo_spacing` has been properly computed, it
is just `effective_echo_spacing` * (ReconMatrixPE - 1).<sup>3</sup> .

* This parameter is
REQUIRED if corresponding "field/distortion" maps acquired with opposing phase
encoding directions are present.

<sup>3</sup>We use the "FSL definition", i.e, the time between the center of the
first "effective" echo and the center of the last "effective" echo.
"""
@defprop TotalReadoutTime{:total_readout_time}::(x -> second_type(x))

"""
The phase encoding direction is defined as the direction along which phase is was
modulated which may result in visible distortions. Note that this is not the
same as the DICOM term `in_plane_phase_encoding_direction` which can have `ROW` or
`COL` values. This parameter is REQUIRED if corresponding fieldmap data is present
or when using multiple runs with different phase encoding directions (which can
be later used for field inhomogeneity correction).
"""
@defprop PhaseEncodingDirection{:phase_encoding_direction}::EncodingDirection=x -> phasedim(x)
phase_encoding_direction!(x::AbstractArray, val) = phasedim!(x, val)

