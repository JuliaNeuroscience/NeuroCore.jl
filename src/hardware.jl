"""
    manufacturer(x) -> String

Returns the manufacturer of the equipment that produced the composite instances.
"""
manufacturer(x) = getter(x, "Manufacturer", String, i -> "")

"""
    manufacturer!(x, val)

Sets the manufacturer of the equipment that produced the composite instances.
"""
manufacturer!(x) = setter!(x, "Manufacturer", String, val)

"""
    manufacturer_model_name(x) -> String

Returns the manufacturer's model name of the equipment that produced the composite instances.
"""
manufacturer_model_name(x) = getter(x, "ManufacturerModelName", String, i -> "")

"""
    manufacturer_model_name!(x, val)

Sets the manufacturer's model name of the equipment that produced the composite instances.
"""
manufacturer_model_name!(x, val) = setter!(x, "ManufacturerModelName", String, val)

"""
    device_serial_number(x) -> String

Returns the serial number of the equipment that produced the composite instances.
A pseudonym can also be used to prevent the equipment from being identifiable,
so long as each pseudonym is unique within the dataset.
"""
device_serial_number(x) = getter(x, "DeviceSerialNumber", String, i -> "00000")

"""
    device_serial_number!(x, val)

Returns the serial number of the equipment that produced the composite instances.
A pseudonym can also be used to prevent the equipment from being identifiable,
so long as each pseudonym is unique within the dataset.
"""
device_serial_number!(x, val) = setter!(x, "DeviceSerialNumber", String, val)

"""
    magnetic_field_strength(x) -> F64Tesla

Returns the nominal field strength of MR magnet in Tesla.
"""
magnetic_field_strength(x) = getter(x, "MagneticFieldStrength", F64Tesla, i -> 3.0u"T")

"""
    magnetic_field_strength!(x, val)

Sets the nominal field strength of MR magnet in Tesla.
"""
magnetic_field_strength!(x, val) = setter!(x, "MagneticFieldStrength", F64Tesla, val)

"""
    receiver_coil_name(x) -> String

Returns the information describing the receiver coil. Corresponds to DICOM Tag
Receive Coil Name, although not all vendors populate that DICOM Tag, in which
case this field can be derived from an appropriate private DICOM field.
"""
receiver_coil_name(x) = getter(x, "ReceiverCoilName", String, i -> "")

"""
    receiver_coil_name!(x, val)

Sets the information describing the receiver coil. Corresponds to DICOM Tag
Receive Coil Name, although not all vendors populate that DICOM Tag, in which
case this field can be derived from an appropriate private DICOM field.
"""
receiver_coil_name!(x, val) = setter!(x, "ReceiverCoilName", String, val)

"""
    receive_coil_active_elements(x) -> String

Returns information describing the active/selected elements of the receiver coil. This
doesn’t correspond to a tag in the DICOM ontology. The vendor-defined
terminology for active coil elements can go in this field. As an example, for
Siemens, coil channels are typically not activated/selected individually, but
rather in pre-defined selectable "groups" of individual channels, and the list
of the "groups" of elements that are active/selected in any given scan
populates the Coil String entry in Siemens’ private DICOM fields (e.g., HEA;HEP
for the Siemens standard 32 ch coil when both the anterior and posterior groups
are activated). This is a flexible field that can be used as most appropriate
for a given vendor and coil to define the "active" coil elements. Since
individual scans can sometimes not have the intended coil elements selected, it
is preferable for this field to be populated directly from the DICOM for each
individual scan, so that it can be used as a mechanism for checking that a
given scan was collected with the intended coil elements selected.
"""
receive_coil_active_elements(x) = getter(x, "ReceiveCoilActiveElements", String, i -> "")

"""
    receive_coil_active_elements!(x, val)

Sets the `receive_coil_active_elements` property

See also: ['receive_coil_active_elements'](@ref)
"""
receive_coil_active_elements!(x, val) = setter!(x, "ReceiveCoilActiveElements", String, val)

"""
    gradient_set_type(x) -> String

Returns the gradient set type. It should be possible to infer the gradient coil
from the scanner model. If not, e.g. because of a custom upgrade or use of a
gradient insert set, then the specifications of the actual gradient coil should
be reported independently.
"""
gradient_set_type(x) = getter(x, "GradientSetType", String, i -> "")

"""
    gradient_set_type!(x, val)

Returns the gradient set type.

See also: ['gradient_set_type'](@ref)
"""
gradient_set_type!(x, val) = setter!(x, "GradientSetType", String, val)

"""
    matrix_coil_mode(x) -> String

Returns the matrix coil mode. A method for reducing the number of independent
channels by combining in analog the signals from multiple coil elements. There
are typically different default modes when using un-accelerated or accelerated
(e.g. GRAPPA, SENSE) imaging.
"""
matrix_coil_mode(x) = getter(x, "MatrixCoilMode", String, i -> "")

"""
    matrix_coil_mode!(x, val)

Sets the matrix coil mode.

See also: ['matrix_coil_mode'](@ref)
"""
matrix_coil_mode!(x, val) = setter!(x, "MatrixCoilMode", String, val)

"""
    coil_combination_method(x) -> String

Returns the coil combination method.

Almost all fMRI studies using phased-array coils use root-sum-of-squares (rSOS)
combination, but other methods exist. The image reconstruction is changed by
the coil combination method (as for the matrix coil mode above), so anything
non-standard should be reported.
"""
coil_combination_method(x) =  getter(x, "CoilCombinationMethod", String, i -> "")

"""
    coil_combination_method!(x, val)

Sets the coil combination method.

See also: ['coil_combination_method'](@ref)
"""
coil_combination_method!(x, val) =  getter(x, "CoilCombinationMethod", String, val)

# TODO: should this be a string or a v"xxx"
"""
    software_versions(x) -> String

Returns the manufacturer’s designation of software version of the equipment
that produced the composite instances.
"""
software_versions(x) = getter(x, "SoftwareVersions", String, i -> "")

"""
    software_versions!(x, val)

Sets the manufacturer’s designation of software version of the equipment
that produced the composite instances.
"""
software_versions!(x, val) = setter!(x, "SoftwareVersions", String, val)
