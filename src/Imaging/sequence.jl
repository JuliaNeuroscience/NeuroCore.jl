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
