module NeuroMetadata

using NeuroCore.AnatomicalAPI
using FieldProperties

export
    EncodingDirection,
    encoding_names,
    freqdim,
    freqdim!,
    phasedim,
    phasedim!,
    slice_start,
    slice_start!,
    slice_end,
    slice_end!,
    slicedim,
    slicedim!,
    slice_duration,
    slice_duration!,
    phase_encoding_direction,
    phase_encoding_direction!,
    slice_encoding_direction,
    slice_encoding_direction!,
    InstitutionInformation,
    HardwareMetadata,
    EncodingDirectionMetadata


"""
    ContrastIngredient

An enumerable type with the following possible values:
* `IODINE`
* `GADOLINIUM`
* `CARBON`
* `DIOXIDE`
* `BARIUM`
* `XENON`
* `UnkownContrast`
"""
@enum ContrastIngredient begin
    IODINE
    GADOLINIUM
    CARBON
    DIOXIDE
    BARIUM
    XENON
    UnkownContrast
end

ContrastIngredient(i::AbstractString) = ContrastIngredient(Symbol(i))

function ContrastIngredient(i::Symbol)
    if i === :IODINE
        return IODINE
    elseif i === :GADOLINIUM
        return GADOLINIUM
    elseif i === :CARBON
        return CARBON
    elseif i === :DIOXIDE
        return DIOXIDE
    elseif i === :BARIUM
        return BARIUM
    elseif i === :XENON
        return XENON
    else
        return UnkownContrast
    end
end

Base.String(i::ContrastIngredient) = String(Symbol(i))
include("mri.jl")
include("encoding_direction.jl")
include("magnetization_transfer.jl")
include("sequence.jl")
include("spatial_encoding.jl")
include("spoiling.jl")
include("time.jl")
include("electrophysiology.jl")
include("institution.jl")
include("hardware.jl")
include("task.jl")

end
