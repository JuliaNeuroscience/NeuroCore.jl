
"""
Specifies whether the magnetization transfer pulse is applied. This parameter
is REQUIRED by all the anatomical images grouped by MTR, MTS and MPM suffixes.
"""
@defprop MTState{:mt_state}::Bool

"""
The frequency offset of the magnetization transfer pulse with respect to the
central H1 Larmor frequency in Hertz (Hz).
"""
@defprop MTOffsetFrequency{:mt_offset_frequency}::(x -> hertz_type(x))

"The excitation bandwidth of the magnetization transfer pulse in Hertz (Hz)."
@defprop MTPulseBandwidth{:mt_pulse_bandwidth}::(x -> hertz_type(x))

"Number of magnetization transfer RF pulses applied before the readout."
@defprop MTNumberOfPulses{:mt_npulses}::Int

# TODO how should this be parameterized
"""
Shape of the magnetization transfer RF pulse waveform. Accepted values:
* HARD
* GAUSSIAN
* GAUSSHANN (gaussian pulse with Hanning window)
* SINC
* SINCHANN (sinc pulse with Hanning window)
* SINCGAUSS (sinc pulse with Gaussian window)
* FERMI
"""
@defprop MTPulseShape{:mt_pulse_shape}

"Duration of the magnetization transfer RF pulse in seconds."
@defprop MTPulseDuration{:mt_pulse_duration}::(x -> second_type(x))

