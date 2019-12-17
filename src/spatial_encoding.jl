"""
    nshots(x) -> Int

Returns the number of RF excitations needed to reconstruct a slice or volume.
Please mind that this is not the same as Echo Train Length which denotes the
number of lines of k-space collected after an excitation.
"""
nshots(x) = getter(x,  "NumberRFExcitations", Int, i -> 0)

"""
    nshots!(x, val)

Sets the number of RF excitations needed to reconstruct a slice or volume.
"""
nshots!(x, val) = setter!(x,  "NumberRFExcitations", Int, val)

"""
    parallel_reduction_factor_in_plane(x) -> Int

The parallel imaging (e.g, GRAPPA) factor. Use the denominator of the fraction
of k-space encoded for each slice. For example, 2 means half of k-space is
encoded.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
"""
parallel_reduction_factor_in_plane(x) = getter(x, "ParallelReductionFactorInPlane", Int, i -> 0)

"""
    parallel_reduction_factor_in_plane!(x, val)

Sets the `parallel_reduction_factor_inplane` property. See
[`parallel_reduction_factor_inplane](@ref) for details.
"""
parallel_reduction_factor_in_plane!(x, val) = setter!(x, "ParallelReductionFactorInPlane", Int, val)

"""
    parallel_acquisition_technique(x) -> String

Returns the type of parallel imaging used (e.g. GRAPPA, SENSE).
"""
parallel_acquisition_technique(x) = getter(x, "ParallelAcquisitionTechnique", String, i -> "")

"""
    parallel_acquisition_technique!(x, val)

Sets the type of parallel imaging used (e.g. GRAPPA, SENSE).
"""
parallel_acquisition_technique!(x, val) = setter!(x, "ParallelAcquisitionTechnique", String, val)

"""
    partial_fourier(x) -> Float64

Returns the fraction of partial Fourier information collected.
"""
partial_fourier(x) = getter(x, "PartialFourier", Float64, i -> 1.0)

"""
    partial_fourier!(x, val)

Set the fraction of partial Fourier information collected.
"""
partial_fourier!(x, val) = setter!(x, "PartialFourier", Float64, val)

"""
    partial_fourier_direction(x) -> String

Returns the direction where only partial Fourier information was collected.
"""
partial_fourier_direction(x) = getter(x, "PartialFourierDirection", String, i -> "")

"""
    partial_fourier_direction!(x, val)

Sets the direction where only partial Fourier information was collected.
"""
partial_fourier_direction!(x, val) = setter!(x, "PartialFourierDirection", String, val)

"""
    phase_encoding_direction(x) -> String

Returns the phase encoding direction.

Possible values: `i`, `j`, `k`, `i-`, `j-`, `k-`. The letters `i`, `j`, `k`
correspond to the first, second and third axis of the data in the NIFTI file.
The polarity of the phase encoding is assumed to go from zero index to maximum
index unless `-` sign is present (then the order is reversed - starting from
the highest index instead of zero). `PhaseEncodingDirection` is defined as the
direction along which phase is was modulated which may result in visible
distortions. Note that this is not the same as the DICOM term
`InPlanePhaseEncodingDirection` which can have `ROW` or `COL` values. This
parameter is REQUIRED if corresponding fieldmap data is present or when using
multiple runs with different phase encoding directions (which can be later used
for field inhomogeneity correction).
"""
phase_encoding_direction(x) = getter(x, "PhaseEncodingDirection", String, i -> "")

"""
    phase_encoding_direction(x) -> String

Sets the phase encoding direction.

See also: [`phase_encoding_direction`](@ref)
"""
phase_encoding_direction!(x, val) = setter!(x, "PhaseEncodingDirection", String, val)

"""
    effective_echo_spacing(x) -> F64Sec

Returns the effective echo spacing.

The "effective" sampling interval, specified in seconds, between lines in the
phase-encoding direction, defined based on the size of the reconstructed image
in the phase direction. It is frequently, but incorrectly, referred to as
"dwell time" (see `DwellTime` parameter below for actual dwell time). It is
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
[here](https://github.com/neurolabusc/dcm_qa/tree/master/In/TotalReadoutTime)
"""
effective_echo_spacing(x) = getter(x, "EffectiveEchoSpacing", F64Sec, i -> 0.0u"s")

"""
    effective_echo_spacing!(x, val)

Sets the effective echo spacing.

See also: [`effective_echo_spacing`](@ref)
"""
effective_echo_spacing!(x, val) = setter!(x, "EffectiveEchoSpacing", F64Sec, val)

"""
    total_readout_time(x) -> F64Sec

Returns the total readout time.

This is actually the "effective" total readout time , defined as the readout
duration, specified in seconds, that would have generated data with the given
level of distortion. It is NOT the actual, physical duration of the readout
train. If `EffectiveEchoSpacing` has been properly computed, it is just
`EffectiveEchoSpacing * (ReconMatrixPE - 1)`.<sup>3</sup> .

* This parameter is
REQUIRED if corresponding "field/distortion" maps acquired with opposing phase
encoding directions are present (see 8.9.4).

<sup>3</sup>We use the "FSL definition", i.e, the time between the center of the
first "effective" echo and the center of the last "effective" echo.
"""
total_readout_time(x) = getter(x, "TotalReadoutTime", F64Sec, i -> 1.0u"s")

"""
    total_readout_time!(x, val)

Sets the total readout time.

See also: [`total_readout_time`](@ref)
"""
total_readout_time!(x, val) = setter!(x, "TotalReadoutTime", F64Sec, val)
