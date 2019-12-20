
# TODO FileIO integration
# TODO HED format should probably involve its own package

"""
    event_table(;kwargs...)

The events table describes timing and other properties of events recorded during
acquisition. Events MAY be either stimuli presented to the participant or participant
responses. A single event file MAY include any combination of stimuli and response
events. Events MAY overlap in time. Please mind that this does not imply that only
so called "event related" study designs are supported (in contrast to "block"
designs) - each "block of events" can be represented by an individual row in the
"_events.tsv" file (with a long duration). Each task events file REQUIRES a
corresponding `task` imaging data file (but a single events file MAY be shared
by multiple imaging data files - see Inheritance principle). The tabular files
consists of one row per event and a set of REQUIRED and OPTIONAL columns:

## Arguments
* `onset::F64Sec`: REQUIRED. Onset (in seconds) of the event measured from the
  beginning of the acquisitionof the first volume in the corresponding task imaging
  data file. If any acquired scans have been discarded before forming the imaging
  data file, ensure that a time of 0 corresponds to the first image stored. In other
  words negative numbers in "onset" are allowed.
* `duration::F64Sec`: REQUIRED. Duration of the event (measured from onset) in
  seconds. Must always be either zero or positive. A "duration" value of zero implies
  that the delta function or event is so short as to be effectively modeled as an impulse.
* `sample_onset::F64Sec`: Onset of the event according to the sampling scheme of
  the recorded modality (i.e., referring to the raw data file that the events.tsv
  file accompanies).
* `trial_type::String`: OPTIONAL. Primary categorisation of each trial to identify
  them as instances of the experimental conditions. For example: for a response
  inhibition task, it could take on values "go" and "no-go" to refer to response
  initiation and response inhibition experimental conditions.
* `response_time::F64Sec`: OPTIONAL. Response time measured in seconds. A negative
  response time can be used to represent preemptive responses and `NaN` denotes a
  missed response.
* `stimulus_file::String`: OPTIONAL. Represents the location of the stimulus file
  (image, video, sound etc.) presented at the given onset time. There are no
  restrictions on the file formats of the stimuli files, but they should be stored
  in the stimuli folder (under the root folder of the dataset; with optional subfolders).
  The values under the stim_file column correspond to a path relative to "/stimuli". For
  example "images/cat03.jpg" will be translated to "/stimuli/images/cat03.jpg".
* `event_marker::AbstractVector{String}`: OPTIONAL. Marker value associated with
  the event (e.g., the value of a TTL trigger that was recorded at the onset of the event).
* `event_description::AbstractVector{String}`: OPTIONAL. Returns Hierarchical Event
  Descriptor (HED) Tag. See Appendix III for details.
"""
function event_table(;
    onset::AbstractVector{F64Sec},
    duration::AbstractVector{F64Sec},
    sample::Union{Nothing}=nothing,
    trial_type::Union{Nothing,AbstractVector{String}}=nothing,
    response_time::Union{Nothing,AbstractVector{F64Sec}}=nothing,
    stim_file::Union{Nothing,AbstractVector{String}}=nothing,
    value::Union{Nothing,Any}=nothing,
    HED::Union{Nothing,AbstractVector{String}}=nothing,
    kwargs...
   )
    t = DataFrame(onset = onset, duration = duration)

    if !isnothing(sample)
        t.sample = sample
    end
    if !isnothing(trial_type)
        t.trial_type = trial_type
    end
    if !isnothing(response_time)
        t.response_time = response_time
    end
    if !isnothing(stim_file)
        t.stim_file = stim_file
    end
    if !isnothing(value)
        t.value = value
    end
    if !isnothing(HED)
        t.HED = HED
    end
    for (k,v) in kwargs
        t.k = v
    end
    return t
end
