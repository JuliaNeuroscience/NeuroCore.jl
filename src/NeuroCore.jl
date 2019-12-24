module NeuroCore

using ImageCore, ImageAxes, Unitful, ImageMetadata, Markdown
using StaticArrays, Rotations, CoordinateTransformations

export CoordinateList,
       NeuroMetadata,
       NeuroMetaArray,
       BIDSMetadata,
       # methods
       calmax,
       calmax!,
       calmin,
       calmin!,
       description,
       description!,
       freqdim,
       freqdim!,
       is_anatomical,
       is_functional,
       is_electrophysiology,
       neurohelp,
       phasedim,
       phasedim!,
       stream_offset,
       slicedim,
       slicedim!,
       slice_end,
       slice_start,
       spatial_offset,
       spatial_units,
       time_units



const OneF64Sec = 1.0u"s"

"F64Sec - A `Float64` type with seconds units."
const F64Sec = typeof(OneF64Sec)

const OneF64Tesla = 1.0u"T"

"F64Tesla - A `Float64` type with tesla units."
const F64Tesla = typeof(OneF64Tesla)


"F64Hertz - A `Float64` type with hertz units."
const OneF64Hz = 1.0u"Hz"
const F64Hz = typeof(OneF64Hz)

"IntHertz - A `Float64` type with degree units."
const OneIntDeg = 1.0u"°"
const IntDeg = typeof(OneIntDeg)

const CoordinateList = Dict{Symbol,NTuple{3,Float64}}

const NeuroAffine{R} = AffineMap{R,SArray{Tuple{3},Float64,1,3}}

include("enums.jl")
include("properties.jl")
include("coordinates.jl")
include("bids_entities.jl")
include("bidsdata.jl")
include("getproperty.jl")
include("metadata.jl")
include("array.jl")
include("traits.jl")

"""
    neurohelp(func[;])

"""
neurohelp(func) = neurohelp(stdout, func)
neurohelp(io::IO, input::Symbol) = neurohelp(io, getproperty(NeuroCore, input))
function neurohelp(io::IO, input)
    buffer = IOBuffer()
    println(buffer, Base.Docs.doc(input))
    Markdown.parse(String(take!(buffer)))
end

end
