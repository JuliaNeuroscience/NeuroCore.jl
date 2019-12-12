
"""
    onset(x) -> Float64

Onset (in seconds) of the event measured from the beginning of the acquisition
of the first volume in the corresponding task imaging data file. If any acquired
scans have been discarded before forming the imaging data file, ensure that a
time of 0 corresponds to the first image stored. In other words negative numbers
in "onset" are allowed.
"""
onset(x) = getter(x, "Onset", Float64, x -> 0.0)

"""
    onset!(x, val)

Sets the `onset` property. See [`onset`](@ref) for more details.
"""
onset!(x, val) = setter!(x, "Onset", Float64, x -> 0.0)

"""
    duration(x) -> Float64

Duration of the event (measured from onset) in seconds. Must always be either
zero or positive. A "duration" value of zero implies that the delta function or
event is so short as to be effectively modeled as an impulse.
"""
duration(x) = getter(x, "Duration", Float64, x -> 0.0)

"""
    duration!(x, val)

Sets the `duration` property. See [`duration`](@ref) for more details.
"""
duration!(x, val) = setter!(x, "Duration", Float64, val)

"""
    sample_onset(x) -> Float64

Onset of the event according to the sampling scheme of the recorded modality
(i.e., referring to the raw data file that the events.tsv file accompanies).
"""
sample_onset(x) = getter(x, "SampleOnset", Float64, x -> 0.0)

"""
    sample_onset!(x, val) -> Float64

Sets the `sample_onset` property. See [`sample_onset`](@ref) for more details.
"""
sample_onset!(x, val) = setter!(x, "SampleOnset", Float64, val)


"""
    trial_type(x) -> String

Primary categorisation of each trial to identify them as instances of the
experimental conditions. For example: for a response inhibition task, it
could take on values "go" and "no-go" to refer to response initiation and
response inhibition experimental conditions.
"""
trial_type(x) = getter(x, "TrialType", String, x -> "")

"""
    response_time(x) -> Float64

OPTIONAL. Response time measured in seconds. A negative response time can
be used to represent preemptive responses and "n/a" denotes a missed
response.
"""
response_time(x) = getter(x, "ResponseTime", Float64, x -> NaN)

"""
    response_time!(x, val)

Sets the `response_time` property. See [`response_time`](@ref) for more details.
"""
response_time!(x, val) = setter!(x, "ResponseTime", Float64, val)

"""
    stimulus_file(x) -> String

OPTIONAL. Represents the location of the stimulus file (image, video,
sound etc.) presented at the given onset time. There are no restrictions on
the file formats of the stimuli files, but they should be stored in the
/stimuli folder (under the root folder of the dataset; with optional
subfolders). The values under the stim_file column correspond to a path
relative to "/stimuli". For example "images/cat03.jpg" will be translated
to "/stimuli/images/cat03.jpg".
"""
stimulus_file(x) = getter(x, "StimulusFile", String, x -> "")

"""
    stimulus_file!(x, val)

Sets the `stimulus_file` property. See [`stimulus_file`](@ref) for more details.
"""
stimulus_file!(x, val) = setter!(x, "StimulusFile", String, val)


"""
    event_marker(x) -> String

OPTIONAL. Marker value associated with the event (e.g., the value of a TTL
trigger that was recorded at the onset of the event).
"""
event_marker(x) = getter(x, "EventMarker", String, x -> "")

"""
    event_marker!(x, val)

Sets the `event_marker` property. See [`event_marker`](@ref) for more details.
"""
event_marker!(x, val) = getter(x, "EventMarker", String, val)


# TODO: Implement HED schema
"""
    event_description(x) -> String

Returns Hierarchical Event Descriptor (HED) Tag. See Appendix III for details.
"""
event_description(x) = getter(x, "EventDescription", String, x -> "")


"""
    event_description!(x, val)

Returns Hierarchical Event Descriptor (HED) Tag. See Appendix III for details.
"""
event_description!(x, val) = setter!(x, "EventDescription", String, val)




