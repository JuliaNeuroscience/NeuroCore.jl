
"""
    nshots(x)
    nshots!(x, val)

The number of RF excitations needed to reconstruct a slice or volume.
Please mind that this is not the same as Echo Train Length which denotes the
number of lines of k-space collected after an excitation.
"""
@defprop NumberShots{:nshots}::Int

"""
    effective_echo_spacing(x)
    effective_echo_spacing!(x, val)

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
@defprop EffectiveEchoSpacing{:effective_echo_spacing}::F64Second

"""
    parallel_acquisition_technique(x)
    parallel_acquisition_technique!(x, val)

The type of parallel imaging used (e.g. GRAPPA, SENSE).
"""
@defprop ParallelAcquisitionTechnique{:parallel_acquisition_technique}::String

"""
    parallel_reduction_factor_in_plane(x)
    parallel_reduction_factor_in_plane!(x, val)

The parallel imaging (e.g, GRAPPA) factor. Use the denominator of the fraction
of k-space encoded for each slice. For example, 2 means half of k-space is encoded.
"""
@defprop ParallelReductionFactor{:parallel_reduction_factor_in_plane}::Int

"""
    partial_fourier(x)
    partial_fourier!(x, val)

The fraction of partial Fourier information collected.
"""
@defprop PartialFourier{:partial_fourier}::Float64

"""
    partial_fourier_direction(x)
    partial_fourier_direction!(x, val)

The direction where only partial Fourier information was collected.
"""
@defprop PartialFourierDirection{:partial_fourier_direction}::String

"""
    total_readout_time(x)
    total_readout_time!(x, val)

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
@defprop TotalReadoutTime{:total_readout_time}::F64Second

