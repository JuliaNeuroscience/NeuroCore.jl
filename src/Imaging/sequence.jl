"""
Returns `Bool` stating if the image saved has been corrected for gradient
nonlinearities by the scanner sequence. Default is `false`.
"""
@defprop NonlinearGradientCorrection{:nonlinear_gradient_correction}::Bool

"""
General description of the pulse sequence used for the scan (i.e. MPRAGE,
Gradient Echo EPI, Spin Echo EPI, Multiband gradient echo EPI).
"""
@defprop PulseSequence{:pulse_sequence}::String

"""
Information beyond pulse sequence type that identifies the specific pulse
sequence used (i.e. "Standard Siemens Sequence distributed with the VB17
software," "Siemens WIP ### version #.##," or "Sequence written by X using a
version compiled on MM/DD/YYYY").
"""
@defprop PulseSequenceDetails{:pulse_sequence_details}::String

"""
A general description of the pulse sequence used for the scan (i.e. MPRAGE,
Gradient Echo EPI, Spin Echo EPI, Multiband gradient echo EPI).
"""
@defprop PulseSequenceType{:pulse_sequence_type}::String

"Description of the type of sequence data acquired."
@defprop ScanningSequence{:scanning_sequence}::String

"Manufacturer’s designation of the sequence name."
@defprop SequenceName{:sequence_name}::String

"Variant of the `scanning_sequence` property."
@defprop SequenceVarient{:sequence_varient}::String

struct SequenceMetadata
    nonlinear_gradient_correction::Bool
    pulse_sequence::String
    pulse_sequence_details::String
    pulse_sequence_type::String
    scanning_sequence::String
    sequence_name::String
    sequence_varient::String
end

@assignprops(
    SequenceMetadata,
    :nonlinear_gradient_correction => nonlinear_gradient_correction,
    :pulse_sequence => pulse_sequence,
    :pulse_sequence_details => pulse_sequence_details,
    :pulse_sequence_type => pulse_sequence_type,
    :scanning_sequence => scanning_sequence,
    :sequence_name => sequence_name,
    :sequence_varient => sequence_varient
)

"""
    SequenceMetadata 


Metadata structure for general MRI sequence information.

## Properties
$(propdoclist(SequenceMetadata))
"""
SequenceMetadata
