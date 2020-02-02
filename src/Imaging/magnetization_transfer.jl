
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


struct MagnetizationTransferMetadata{H,S}
    mt_state::Bool
    mt_offset_frequency::H
    mt_pulse_bandwidth::H
    mt_npulses::Int
    mt_pulse_shape::Symbol
    mt_pulse_duration::S
end

@properties MagnetizationTransferMetadata begin
    mt_state(self) => :mt_state
    mt_offset_frequency(self) => :mt_offset_frequency
    mt_pulse_bandwidth(self) => :mt_pulse_bandwidth
    mt_npulses(self) => :mt_npulses
    mt_pulse_shape(self) => :mt_pulse_shape
    mt_pulse_duration(self) => :mt_pulse_duration
end

"""
    MagnetizationTransferMetadata 

Metadata structure for information concerning MRI magnetization transfer pulse.
"""
MagnetizationTransferMetadata

