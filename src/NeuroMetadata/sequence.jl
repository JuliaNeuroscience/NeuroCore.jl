"""
    nonlinear_gradient_correction(x)
    nonlinear_gradient_correction!(x, val)

Returns `Bool` stating if the image saved has been corrected for gradient
nonlinearities by the scanner sequence. Default is `false`.
"""
@defprop NonlinearGradientCorrection{:nonlinear_gradient_correction}::Bool

"""
    pulse_sequence(x)
    pulse_sequence!(x, val)

General description of the pulse sequence used for the scan (i.e. MPRAGE,
Gradient Echo EPI, Spin Echo EPI, Multiband gradient echo EPI).
"""
@defprop PulseSequence{:pulse_sequence}::String

"""
    pulse_sequence_details(x)
    pulse_sequence_details!(x, val)

Information beyond pulse sequence type that identifies the specific pulse
sequence used (i.e. "Standard Siemens Sequence distributed with the VB17
software," "Siemens WIP ### version #.##," or "Sequence written by X using a
version compiled on MM/DD/YYYY").
"""
@defprop PulseSequenceDetails{:pulse_sequence_details}::String

"""
    pulse_seqtype(x)
    pulse_seqtype!(x, val)

A general description of the pulse sequence used for the scan (i.e. MPRAGE,
Gradient Echo EPI, Spin Echo EPI, Multiband gradient echo EPI).
"""
@defprop PulseSequenceType{:pulse_seqtype}::String

"""
    scanning_sequence(x)
    scanning_sequence!(x, val)

Description of the type of sequence data acquired.
"""
@defprop ScanningSequence{:scanning_sequence}::String

"""
    sequence_name(x)
    sequence_name!(x, val)

Manufacturer’s designation of the sequence name.
"""
@defprop SequenceName{:sequence_name}::String

"""
    sequence_varient(x)
    sequence_varient!(x, val)

Variant of the `scanning_sequence` property.
"""
@defprop SequenceVarient{:sequence_varient}::String
"""
    SequenceMetadata 

Metadata structure for general MRI sequence information.

## Supported Properties
$(description_list(nonlinear_gradient_correction, pulse_sequence, pulse_sequence_details,
                   pulse_sequence_type, scanning_sequence, sequence_name, sequence_varient))
"""
struct SequenceMetadata
    nonlinear_gradient_correction::Bool
    pulse_sequence::String
    pulse_sequence_details::String
    pulse_sequence_type::String
    scanning_sequence::String
    sequence_name::String
    sequence_varient::String
end

@properties SequenceMetadata begin
    nonlinear_gradient_correction(self) => :nonlinear_gradient_correction
    pulse_sequence(self) => :pulse_sequence
    pulse_sequence_details(self) => :pulse_sequence_details
    pulse_seqtype(self) => :pulse_sequence_type
    scanning_sequence(self) => :scanning_sequence
    sequence_name(self) => :sequence_name
    sequence_varient(self) => :sequence_varient
end

