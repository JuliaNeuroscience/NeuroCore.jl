
"""
`nchannels::Int`: number of channels present
"""
@defprop NumberOfChannels{:nchannels}::Int

"""
Frequencies used for the high-pass filter applied to the channel in Hz. If no high-pass filter applied, use n/a.
"""
@defprop HighCutOff{:high_cutoff}::F64Hz

"""
Frequencies used for the low-pass filter applied to the channel in Hz.
If no low-pass filter applied, use n/a. Note that hardware anti-aliasing in A/D
conversion of all MEG/EEG electronics applies a low-pass filter; specify its
frequency here if applicable.
"""
@defprop LowCutOff{:low_cutoff}::F64Hz

"""
OPTIONAL. Frequencies used for the notch filter applied to the channel, in Hz.
If no notch filter applied, use n/a.
"""
@defprop Notch{:notch}::F64Hz

"Temporal software filters applied."
@defprop SoftwareFilters{:software_filterssoftware_filters}



struct ChannelMetadata{M} <: AbstractMetadata{M}
    modality
    units
    low_cutoff
    high_cutoff
    notch
    status
    status_description
    meta::M
end

@assignprops(
    ChannelMetadata,
    meta => dictextension(description)
)
