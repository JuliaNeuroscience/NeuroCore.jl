"""
    CogAtlasID(x) -> String

URL of the corresponding [Cognitive Atlas Task](https://www.cognitiveatlas.org/) term.
"""
CogAtlasID(x) =  getter(x, :CogAtlasID, String, i -> "")
CogAtlasID!(x, val) =  setter!(x, :CogAtlasID, String, val)

"""
    CogPOID(x) -> String

URL of the corresponding [CogPO](http://www.cogpo.org/) term.
"""
CogPOID(x) =  getter(x, :CogPOID, String, i -> "")
CogPOID!(x, val) =  setter!(x, :CogPOID, String, val)

"""
    dewar_position(x)

Position of the dewar during the MEG scan: upright, supine or degrees of angle
from vertical: for example on CTF systems, upright=15°, supine = 90°.

Corresponds to BIDS "DewarPosition".
"""
dewar_position(x) = getter(x, :dewar_position, IntDeg, i -> OneIntDeg)
dewar_position!(x, val) = setter!(x, :dewar_position, IntDeg, val)

"""
    eeg_electrode_groups(x) -> String

Field to describe the way electrodes are grouped into strips, grids or depth probes
e.g., `Dict(:grid1 => "10x8 grid on left temporal pole", :strip2 => "1x8 electrode strip on xxx")`.

Corresponds to BIDS "EEGElectrodeGroups".
"""
eeg_electrode_groups(x) = getter(x, :eeg_electrode_groups, Dict{Symbol,String}, i -> Dict{Symbol,String}())
eeg_electrode_groups!(x, val) = setter!(x, :eeg_electrode_groups, Dict{Symbol,String}, val)

"""
    eeg_ground(x) -> String

Description of the location of the ground electrode ("placed on right mastoid (M2)").

Corresponds to BIDS "EEGGround".
"""
eeg_ground(x) = getter(x, :eeg_ground, String, i -> "")
eeg_ground!(x, val) = setter!(x, :eeg_ground, String, val)

"""
    eeg_placement_scheme(x)

Freeform description of the placement of the iEEG electrodes.
Left/right/bilateral/depth/surface (e.g., "left frontal grid and bilateral
hippocampal depth" or "surface strip and STN depth" or "clinical indication
bitemporal, bilateral temporal strips and left grid").

Corresponds to BIDS "EEGPlacementScheme".
"""
eeg_placement_scheme(x) = getter(x, :eeg_placement_scheme, String, i -> "")
eeg_placement_scheme!(x, val) = setter!(x, :eeg_placement_scheme, String, val)

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

"""
    fiducial_description(x) -> String

A freeform text field documenting the anatomical landmarks that were used and how
the head localization coils were placed relative to these. This field can describe,
for instance, whether the true anatomical locations of the left and right pre-auricular
points were used and digitized, or rather whether they were defined as the intersection
between the tragus and the helix (the entry of the ear canal), or any other anatomical
description of selected points in the vicinity of the ears.

Corresponds to BIDS "FiducialDescription".
"""
fiducial_description(x) = getter(x, :fiducial_description, String, i -> "")
fiducial_description!(x, val) = setter!(x, :fiducial_description, String, val)

"""
    instructions(x) -> String

Text of the instructions given to participants before the scan. This is especially
important in context of resting state fMRI and distinguishing between eyes open and
eyes closed paradigms.

Corresponds to BIDS "Instructions".
"""
instructions(x) = getter(x, :instructions, String, i -> "")
instructions!(x, val) = setter!(x, :instructions, String, val)

"""
    intended_for(x) -> Vector{String}

Path or list of path relative to the subject subfolder pointing to the structural
MRI, possibly of different types if a list is specified, to be used with the MEG
recording. The path(s) need(s) to use forward slashes instead of backward slashes
(e.g. ses-/anat/sub-01_T1w.nii.gz).

Corresponds to BIDS "IntendedFor".
"""
intended_for(x) = getter(x, :intended_for, Vector{String}, i -> String[])
intended_for!(x, val) = setter!(x, :intended_for, Vector{String}, val)

"""
    power_line_frequency(x) -> F64Hz

Frequency (in Hz) of the power grid at the geographical location of the EEG
instrument (i.e., 50 or 60).

Corresponds to BIDS "PowerLineFrequency".
"""
power_line_frequency(x) = getter(x, :power_line_frequency, F64Hz, i -> 1.0u"Hz")
power_line_frequency!(x, val) = setter!(x, :power_line_frequency, F64Hz, val)

"""
    recording_duration(x) -> F64Sec

Length of the recording in seconds (e.g., 3600)

Corresponds to BIDS "RecordingDuration".
"""
recording_duration(x) = getter(x, :recording_duration, F64Sec, OneF64Sec)
recording_duration!(x, val) = setter!(x, :recording_duration, F64Sec, val)

# TODO: should this return an enumerable
"""
    recording_type(x) -> String

Defines whether the recording is "continuous", "discontinuous" or "epoched";
this latter limited to time windows about events of interest (e.g., stimulus
presentations, subject responses etc.)

Corresponds to BIDS "RecordingType".
"""
recording_type(x) = getter(x, :recording_type, String, i -> "")
recording_type!(x, val) = setter!(x, :recording_type, String, val)

"""
    start_time(x) -> F64Sec

Start time in seconds in relation to the start of acquisition of the first data
sample in the corresponding neural dataset (negative values are allowed).

Corresponds to BIDS "StartTime".
"""
start_time(x) = first(timaxis(x))

"""
    task_description(x) -> String

Longer description of the task.

Corresponds to BIDS "TaskDescription".
"""
task_description(x) = getter(x, :task_description, String, i -> "")
task_description!(x, val) = setter!(x, :task_description, String, val)

"""
    task_name(x) -> String

Name of the task. No two tasks should have the same name. Task label (task-) included
in the file name is derived from this field by removing all non alphanumeric
([a-zA-Z0-9]) characters. For example task name faces n-back will corresponds to
task label facesnback. A RECOMMENDED convention is to name resting state task using
labels beginning with rest.

Corresponds to BIDS "TaskName".
"""
task_name(x) = getter(x, :task_name, String, i -> "")
task_name!(x, val) = setter!(x, :task_name, String, val)
