module EncodingDirections

using FieldProperties

export
    EncodingDirection,
    FrequencyDimension,
    freqdim,
    freqdim!,
    PhaseDimension,
    phasedim,
    phasedim!,
    SliceStart,
    slice_start,
    slice_start!,
    SliceEnd,
    slice_end,
    slice_end!,
    SliceDimension,
    slicedim,
    slicedim!,
    SliceDuration,
    slice_duration,
    slice_duration!,
    PhaseEncodingDirection,
    phase_encoding_direction,
    phase_encoding_direction!,
    SliceEncodingDirection,
    slice_encoding_direction,
    slice_encoding_direction!,
    EncodingDirectionMetadata


"""
    EncodingDirection

Possible values: `ipos`, `jpos`, `kpos`, `ineg, `jneg`, `kneg` (the axis of the NIfTI data along which
slices were acquired, and the direction in which SliceTiming is defined with
respect to). `ipos`, `jpos`, `kpos` identifiers correspond to the first, second and third axis
of the data in the NIfTI file. `*neg` indicates that the contents of
SliceTiming are defined in reverse order - that is, the first entry corresponds
to the slice with the largest index, and the final entry corresponds to slice
index zero. 
"""
@enum EncodingDirection begin
    ipos = 1
    ineg = -1
    jpos = 2
    jneg = -2
    kpos = 3
    kneg = -3
end
EncodingDirection(e::AbstractString) = EncodingDirection(Symbol(e))
function EncodingDirection(e::Symbol)
    if  (e === Symbol("i")) | (e === Symbol("ipos"))
        return ipos
    elseif (e === Symbol("i-")) | (e === Symbol("ineg"))
        return ineg
    elseif  (e === Symbol("j")) | (e === Symbol("jpos"))
        return jpos
    elseif (e === Symbol("j-")) | (e === Symbol("jneg"))
        return jneg
    elseif  (e === Symbol("k")) | (e === Symbol("kpos"))
        return kpos
    elseif (e === Symbol("k-")) | (e === Symbol("kneg"))
        return kneg
    else
        error("$e is not a supported encoding direction.")
    end
end
Base.String(e::EncodingDirection) = String(Symbol(e))

"Which spatial dimension (1, 2, or 3) corresponds to phase acquisition."
@defprop FrequencyDimension{:freqdim}::Int

"Which spatial dimension (1, 2, or 3) corresponds to phase acquisition."
@defprop PhaseDimension{:phasedim}::Int

"Which slice corresponds to the first slice acquired during MRI acquisition (i.e. not padded slices)."
@defprop SliceStart{:slice_start}::Int

"Which slice corresponds to the last slice acquired during MRI acquisition (i.e. not padded slices)."
@defprop SliceEnd{:slice_end}::Int

"Which dimension slices where acquired at throughout MRI acquisition."
@defprop SliceDimension{:slicedim}::Int

"Time to acquire one slice"
@defprop SliceDuration{:slice_duration}::Float64

"""
    phase_encoding_direction(x) -> EncodingDirection

The phase encoding direction is defined as the direction along which phase was
modulated which may result in visible distortions. Note that this is not the
same as the DICOM term "in_plane_phase_encoding_direction" which can have "ROW" or
"COL" values. This parameter is REQUIRED if corresponding fieldmap data is present
or when using multiple runs with different phase encoding directions (which can
be later used for field inhomogeneity correction).
"""
@defprop PhaseEncodingDirection{:phase_encoding_direction}::EncodingDirection begin
    @getproperty self -> EncodingDirection(phasedim(self))
    @setproperty! (self, val) -> phasedim!(self, val)
end

"""
    slice_encoding_direction(x) -> EncodingDirection

Values ending in "*neg" indicate that the contents of slice_timing are defined
in reverse order (the first entry corresponds to the slice with the largest index,
and the final entry corresponds to slice index zero. When present, the axis
defined by `slice_encoding` needs to be consistent with the `slicedim` field in the
NIfTI header. When absent, the entries in slice_timing must be in the order of increasing
slice index as defined by the NIfTI header.
"""
@defprop SliceEncodingDirection{:slice_encoding_direction}::EncodingDirection begin
    @getproperty self -> EncodingDirection(slicedim(self))
    @setproperty! (self, val) -> slicedim!(self, val)
end

struct EncodingDirectionMetadata
    freqdim::Int
    phasedim::Int
    slicedim::Int
    slice_start::Int
    slice_end::Int
    slice_duration::Float64
end

@properties EncodingDirectionMetadata begin
    freqdim(self) => :freqdim
    phasedim(self) => :phasedim
    slicedim(self) => :slicedim
    slice_start(self) => :slice_start
    slice_end(self) => :slice_end
    slice_duration(self) => :slice_duration
    slice_encoding_direction(self) -> slice_encoding_direction(self)
    phase_encoding_direction(self) -> phase_encoding_direction(self)
end

"""
    EncodingDirectionMetadata 

Metadata structure for general MRI sequence information.

## Supported Properties
$(description_list(freqdim, phasedim, slicedim, slice_start, slice_end, slice_duration,slice_encoding_direction,phase_encoding_direction))

## Examples

```jldoctest
julia> using NeuroCore.EncodingDirections

julia> m = EncodingDirectionMetadata(1, 2, 3, 4, 5, 6)
EncodingDirectionMetadata(1, 2, 3, 4, 5, 6.0)

julia> m.slice_encoding_direction
kpos::EncodingDirection = 3

julia> m.phase_encoding_direction
jpos::EncodingDirection = 2

julia> m.freqdim
1

julia> m.phasedim
2

julia> m.slicedim
3

julia> m.slice_start
4

julia> m.slice_end
5

julia> m.slice_duration
6.0
```
"""
EncodingDirectionMetadata

end
