
#=
fiducial_space
anatomical_space
electrode_space
=#

"""
Field to describe the way electrodes are grouped into strips, grids or depth probes
e.g., `Dict(:grid1 => "10x8 grid on left temporal pole", :strip2 => "1x8 electrode strip on xxx")`.
"""
@defprop ElectrodeGroups{:electrode_groups}

"""
Description of the location of the ground electrode ("placed on right mastoid (M2)").
"""
@defprop GroundElectrode{:ground_electrode}

"""
Freeform description of the placement of the iEEG electrodes.
Left/right/bilateral/depth/surface (e.g., "left frontal grid and bilateral
hippocampal depth" or "surface strip and STN depth" or "clinical indication
bitemporal, bilateral temporal strips and left grid").
"""
@defprop PlacementScheme{:placement_scheme}
eeg_placement_scheme(x) = getter(x, :eeg_placement_scheme, String, i -> "")
eeg_placement_scheme!(x, val) = setter!(x, :eeg_placement_scheme, String, val)


struct ElectrodeMetadata{M} <: AbstractMetadata{M}
    modality
    material
    impedance
    meta::M
end

@assignprops(
    ElectrodeMetadata,
    meta => DictExtension(InendedFor)
)

"""
`powerline_frequency::F64Hz`: Frequency (in Hz) of the power grid at the geographical location of the EEG instrument (i.e., 50 or 60).
"""
@defprop PowerlineFrequency{:powerline_frequency}::F64Hz
