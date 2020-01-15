module NeuroCore

using MetadataUtils

using ImageCore, ImageAxes, Unitful, ImageMetadata, Markdown
using StaticArrays, Rotations, CoordinateTransformations

export CoordinateList,
       NeuroMetadata,
       NeuroMetaArray,
       BIDSMetadata,
       # methods
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

const OnekOhm = 1.0u"kΩ"
const F64kOhm = typeof(OnekOhm)

const CoordinateList = Dict{Symbol,NTuple{3,Float64}}

const NeuroAffine{R} = AffineMap{R,SArray{Tuple{3},Float64,1,3}}

include("enums.jl")
include("./Imaging/Imaging.jl")
include("coordinates.jl")
include("bids.jl")
include("array.jl")
include("traits.jl")

end
