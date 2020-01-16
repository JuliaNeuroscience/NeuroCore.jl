"""
Position of the dewar during the MEG scan: upright, supine or degrees of angle
from vertical: for example on CTF systems, upright=15°, supine = 90°.
"""
@defprop DewarPosition{:dwar_position}::IntDeg


"""
    electrical_stimulation(x) -> Bool

Boolean field to specify if electrical stimulation was done during the recording
(options are `true` or `false`). Parameters for event-like stimulation should be
specified in the _events.tsv file.

Corresponds to BIDS "ElectricalStimulation".
"""
electrical_stimulation(x) = getter(x, :electrical_stimulation, Bool, i -> false)
electrical_stimulation!(x, val) = setter!(x, :electrical_stimulation, Bool, val)

"""
    electrical_stimulation_parameters(x) -> String

Free form description of stimulation parameters, such as frequency, shape etc.
Specific onsets can be specified in the _events.tsv file. Specific shapes can be
described here in freeform text.

Corresponds to BIDS "ElectricalStimulationParameters".
"""
electrical_stimulation_parameters(x) = getter(x, :electrical_stimulation_parameters, String, i -> "")
electrical_stimulation_parameters!(x, val) = setter!(x, :electrical_stimulation_parameters, String, val)

"""
    epoch_length(x) -> F64Sec

Duration of individual epochs in seconds (e.g., 1) in case of epoched data. If
recording was continuous or discontinuous, leave out the field.

Corresponds to BIDS "EpochLength".
"""
epoch_length(x) = getter(x, :epoch_length, F64Sec, OneF64Sec)
epoch_length!(x, val) = setter!(x, :epoch_length, F64Sec, val)

