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

