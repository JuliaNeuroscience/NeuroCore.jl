
"`nchannels::Int`: number of channels present"
@defprop NumberOfChannels{:nchannels}::Int

"Frequencies used for the high-pass filter applied to the channel in Hz."
@defprop HighCutOff{:high_cutoff}::F64Hz

"""
Frequencies used for the low-pass filter applied to the channel in Hz.
If no low-pass filter applied, use n/a. Note that hardware anti-aliasing in A/D
conversion of all MEG/EEG electronics applies a low-pass filter; specify its
frequency here if applicable.
"""
@defprop LowCutOff{:low_cutoff}::F64Hz

"Frequencies used for the notch filter applied to the channel, in Hz."
@defprop Notch{:notch}::F64Hz

"Temporal software filters applied."
@defprop SoftwareFilters{:software_filterssoftware_filters}

"""
Field to describe the way electrodes are grouped into strips, grids or depth probes
e.g., `Dict(:grid1 => "10x8 grid on left temporal pole", :strip2 => "1x8 electrode strip on xxx")`.
"""
@defprop ElectrodeGroups{:electrode_groups}

"Description of the location of the ground electrode (\"placed on right mastoid (M2)\")."
@defprop GroundElectrode{:ground_electrode}

"""
Freeform description of the placement of the iEEG electrodes.
Left/right/bilateral/depth/surface (e.g., "left frontal grid and bilateral
hippocampal depth" or "surface strip and STN depth" or "clinical indication
bitemporal, bilateral temporal strips and left grid").
"""
@defprop PlacementScheme{:placement_scheme}

"""
`power_line_frequency::F64Hz`: Frequency (in Hz) of the power grid at the geographical location of the EEG instrument (i.e., 50 or 60).
"""
@defprop PowerlineFrequency{:power_line_frequency}::F64Hz

"""
Position of the dewar during the MEG scan: upright, supine or degrees of angle
from vertical: for example on CTF systems, upright=15°, supine = 90°.
"""
@defprop DewarPosition{:dwar_position}::IntDeg

#### iEEG
"""
Boolean field to specify if electrical stimulation was done during the recording
(options are `true` or `false`). Parameters for event-like stimulation should be
specified in the _events.tsv file.
"""
@defprop ElectricalStimulation{:electrical_stimulation}::Bool

"""
Free form description of stimulation parameters, such as frequency, shape etc.
Specific onsets can be specified in the _events.tsv file. Specific shapes can be
described here in freeform text.
"""
@defprop ElectricalStimulationParameters{:electrical_stimulation_parameters}::String

"""
Duration of individual epochs in seconds (e.g., 1) in case of epoched data. If
recording was continuous or discontinuous, leave out the field.
"""
@defprop EpochLength{:epoch_length}::F64Sec
