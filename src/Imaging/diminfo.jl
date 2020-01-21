
"""
    freqdim(x) -> Int

Which spatial dimension (1, 2, or 3) corresponds to phase acquisition. If not
applicable to scan type defaults to `1`.
"""
freqdim(x) = getter(x, :freqdim, Int, 1)
freqdim!(x, val) = setter!(x, :freqdim, Int, val)

"""
    phasedim(x) -> Int

Which spatial dimension (1, 2, or 3) corresponds to phase acquisition.
"""
phasedim(x) = getter(x, :phasedim, Int, i -> 1)
phasedim!(x, val) = setter!(x, :phasedim, Int, val)

"""
    slice_start(x) -> Int

Which slice corresponds to the first slice acquired during MRI acquisition
(i.e. not padded slices). Defaults to `1`.
"""
slice_start(x) = getter(x, :slice_start, Int, i -> 1)
slice_start!(x, val) = setter!(x, :slice_start, Int, val)

"""
    slice_end(x) -> Int

Which slice corresponds to the last slice acquired during MRI acquisition
(i.e. not padded slices).
"""
slice_end(x) = getter(x, :slice_end, Int, i -> 1)
slice_end!(x, val) = setter!(x, :slice_end, Int, val)

"""
    slicedim(x) -> Int

Which dimension slices where acquired at throughout MRI acquisition.
"""
slicedim(x) = getter(x, :slicedim, Int, i -> 1)
slicedim!(x, val) = setter!(x, :slicedim, Int, val)
