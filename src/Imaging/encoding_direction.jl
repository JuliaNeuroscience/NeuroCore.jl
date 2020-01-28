"""
    EncodingDirection

Possible values: `i`, `j`, `k`, `ineg, `jneg`, `kneg` (the axis of the NIfTI data along which
slices were acquired, and the direction in which SliceTiming is defined with
respect to). `i`, `j`, `k` identifiers correspond to the first, second and third axis
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
@defprop SliceDim{:slicedim}::Int

"Time to acquire one slice"
@defprop SliceDuration{:slice_duration}::Float64


"""
The phase encoding direction is defined as the direction along which phase is was
modulated which may result in visible distortions. Note that this is not the
same as the DICOM term `in_plane_phase_encoding_direction` which can have `ROW` or
`COL` values. This parameter is REQUIRED if corresponding fieldmap data is present
or when using multiple runs with different phase encoding directions (which can
be later used for field inhomogeneity correction).
"""
@defprop PhaseEncodingDirection{:phase_encoding_direction}::EncodingDirection=x -> phasedim(x)
phase_encoding_direction!(x::AbstractArray, val) = phasedim!(x, val)

"""
Possible values: `i`, `j`, `k`, `ineg, `jneg`, `kneg` (the axis of the NIfTI data along which
slices were acquired, and the direction in which slice_timing is defined with
respect to). `i`, `j`, `k` identifiers correspond to the first, second and third axis
of the data in the NIfTI file. `*neg` indicates that the contents of
slice_timing are defined in reverse order - that is, the first entry corresponds
to the slice with the largest index, and the final entry corresponds to slice
index zero. When present, the axis defined by `slice_encoding` needs to be
consistent with the ‘slicedim’ field in the NIfTI header. When absent, the
entries in slice_timing must be in the order of increasing slice index as defined
by the NIfTI header.
"""
@defprop SliceEncodingDirection{:slice_encoding_direction}::EncodingDirection=x -> slicedim(x)
slice_encoding_direction!(x::AbstractArray, val) = slicedim!(x, val)

struct EncodingDirectionMetadata
    freqdim::Int
    phasedim::Int
    slicedim::Int
    slice_start::Int
    slice_end::Int
    slice_duration::Float64
end

@assignprops(
    EncodingDirectionMetadata,
    :freqdim => freqdim,
    :phasedim => phasedim,
    :slicedim => slicedim,
    :slice_start => slice_start,
    :slice_end => slice_end,
    :slice_duration => slice_duration
)

"""
    EncodingDirectionMetadata 

Metadata structure for general MRI sequence information.

## Properties
$(propdoclist(EncodingDirectionMetadata))
"""
EncodingDirectionMetadata
