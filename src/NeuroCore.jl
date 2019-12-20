module NeuroCore

using ImageCore, ImageAxes, Unitful, ImageMetadata, Markdown

export NeuroMetadata,
       NeuroMetaArray,
       BIDSMetadata,
       neurohelp
       #=
       calmax,
       calmax!,
       calmin,
       calmin!,
       magic_bytes,
       magic_bytes!
       =#

const OneF64Sec = 1.0u"s"
const F64Sec = typeof(OneF64Sec)

const OneF64Tesla = 1.0u"T"
const F64Tesla = typeof(OneF64Tesla)

const OneF64Hz = 1.0u"Hz"
const F64Hz = typeof(OneF64Hz)

const OneIntDeg = 1.0u"°"
const IntDeg = typeof(OneIntDeg)

const CoordinateList = Dict{Symbol,NTuple{3,Float64}}

include("enums.jl")
include("properties.jl")
include("coordinates.jl")
include("bids_entities.jl")
include("modalities.jl")
include("modality_agnostic.jl")
include("event_table.jl")
include("getproperty.jl")
include("bidsmetadata.jl")
include("metadata.jl")
include("array.jl")

"""
    neurohelp(func[; extended = false])

For help on a specific function's arguments, type `help_arguments(function_name)`.

For help on a specific function's attributes, type `help_attributes(plot_Type)`.

Use the optional `extended = true` keyword argument to see more details.
"""
neurohelp(func; kw_args...) = neurohelp(stdout, func; kw_args...) #defaults to STDOUT

function neurohelp(io::IO, input::Symbol; extended = false)
    return neurohelp(io, getproperty(NeuroCore, input); extended=extended)
end
function neurohelp(io::IO, input; extended = false)
    buffer = IOBuffer()
    println(buffer, Base.Docs.doc(input))
    Markdown.parse(String(take!(buffer)))
end

end
