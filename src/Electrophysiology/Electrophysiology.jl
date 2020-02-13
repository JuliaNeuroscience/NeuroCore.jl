
"""
    nchannels(x) -> Int
    nchannels!(x, val)

Number of channels present
"""
@defprop NumberOfChannels{:nchannels}::Int

"""
    high_cutoff(x) -> Hz
    high_cutoff!(x, val)

Frequencies used for the high-pass filter applied to the channel in Hz.
"""
@defprop HighCutOff{:high_cutoff}::F64Hertz

"""
    low_cutoff(x) -> Hz
    low_cutoff!(x, val)

Frequencies used for the low-pass filter applied to the channel in Hz.
If no low-pass filter applied, use n/a. Note that hardware anti-aliasing in A/D
conversion of all MEG/EEG electronics applies a low-pass filter; specify its
frequency here if applicable.
"""
@defprop LowCutOff{:low_cutoff}::F64Hertz

"""
    notch_filter(x) -> Hz
    notch_filter!(x, val)

Frequencies used for the notch filter applied to the channel, in Hz.
"""
@defprop NotchFilter{:notch_filter}::F64Hertz

"""
    software_filters(x)
    software_filters!(x, val)

Temporal software filters applied.
"""
@defprop SoftwareFilters{:software_filters}

"""
    electrode_groups(x)
    electrode_groups!(x, val)

Field to describe the way electrodes are grouped into strips, grids or depth probes
e.g., `Dict(:grid1 => "10x8 grid on left temporal pole", :strip2 => "1x8 electrode strip on xxx")`.
"""
@defprop ElectrodeGroups{:electrode_groups}

"""
    ground_electrode(x)
    ground_electrode!(x, val)

Description of the location of the ground electrode (\"placed on right mastoid (M2)\").
"""
@defprop GroundElectrode{:ground_electrode}

"""
    placement_scheme(x)
    placement_scheme!(x, val)

Freeform description of the placement of the iEEG electrodes.
Left/right/bilateral/depth/surface (e.g., "left frontal grid and bilateral
hippocampal depth" or "surface strip and STN depth" or "clinical indication
bitemporal, bilateral temporal strips and left grid").
"""
@defprop PlacementScheme{:placement_scheme}

"""
    power_line_frequency(x)
    power_line_frequency!(x, val)

`power_line_frequency::F64Hz`: Frequency (in Hz) of the power grid at the geographical location of the EEG instrument (i.e., 50 or 60).
"""
@defprop PowerlineFrequency{:power_line_frequency}::F64Hertz

"""
    dewar_position(x)
    dewar_position!(x, val)

Position of the dewar during the MEG scan: upright, supine or degrees of angle
from vertical: for example on CTF systems, upright=15°, supine = 90°.
"""
@defprop DewarPosition{:dewar_position}::IntDegree

#### iEEG
"""
    electrical_stimulation(x)
    electrical_stimulation!(x, val)

Boolean field to specify if electrical stimulation was done during the recording
(options are `true` or `false`). Parameters for event-like stimulation should be
specified in the _events.tsv file.
"""
@defprop ElectricalStimulation{:electrical_stimulation}::Bool

"""
    electrical_stimulation_parameters(x)
    electrical_stimulation_parameters!(x, val)

Free form description of stimulation parameters, such as frequency, shape etc.
Specific onsets can be specified in the _events.tsv file. Specific shapes can be
described here in freeform text.
"""
@defprop ElectricalStimulationParameters{:electrical_stimulation_parameters}::String

"""
    epoch_length(x)
    epoch_length!(x, val)

Duration of individual epochs in seconds (e.g., 1) in case of epoched data. If
recording was continuous or discontinuous, leave out the field.
"""
@defprop EpochLength{:epoch_length}::F64Second

