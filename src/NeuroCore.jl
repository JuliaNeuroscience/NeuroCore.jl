module NeuroCore

using ImageCore, ImageAxes, Unitful, ImageMetadata #CoordinateTransformations, Rotations

export NeuroMetadata,
       NeuroMetaArray,
       event_onset,
       event_onset!,
       event_duration,
       event_duration!,
       trial_type,
       trial_type!,
       response_time!,
       stimulus_file,
       stimulus_file!,
       event_marker,
       event_marker!,
       event_description,
       event_description!,
       calmax,
       calmax!,
       calmin,
       calmin!,
       magic_bytes,
       magic_bytes!

const OneF64Sec = 1.0u"s"
const F64Sec = typeof(OneF64Sec)

const OneF64Tesla = 1.0u"T"
const F64Tesla = typeof(OneF64Tesla)

const OneF64Hz = 1.0u"Hz"
const F64Hz = typeof(OneF64Hz)

const OneIntDeg = 1.0u"°"
const IntDeg = typeof(OneIntDeg)

include("properties.jl")
include("coordinates.jl")
include("bids_entities.jl")
include("modalities.jl")
include("modality_agnostic.jl")
include("spatial_properties.jl")
include("task_events.jl")
include("data.jl")
include("metadata.jl")
include("getproperty.jl")
include("array.jl")

function help(s::Symbol)
    t = getfield(NeuroCore, Docs.META)[Docs.Binding(NeuroCore, s)].docs[Tuple{Any}].text
    for t_i in t
        println(t_i)
    end
end

end
