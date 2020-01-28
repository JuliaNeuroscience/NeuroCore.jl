"The manufacturer of the equipment that produced the composite instances."
@defprop Manufacturer{:manufacturer}::String

"The manufacturer's model name of the equipment that produced the composite instances."
@defprop ManufacturerModelName{:manufacturer_model_name}::String

"""
The serial number of the equipment that produced the composite instances. A
pseudonym can also be used to prevent the equipment from being identifiable,
so long as each pseudonym is unique within the dataset.
"""
@defprop DeviceSerialNumber{:device_serial_number}::String


"The manufacturer’s designation of software version of the equipment that produced the composite instances."
@defprop SoftwareVersions{:software_versions}::String

"Institution defined name of the machine that produced the composite instances."
@defprop StationName{:station_name}::String

struct HardwareMetadata{M} <: AbstractMetadata{M}
    manufacturer::String
    model::String
    serial_number::String
    extension::M
end

function HardwareMetadata(manufacturer, model, serial_number; kwargs...)
    return HardwareMetadata(manufacturer, model, serial_number, Metadata(; kwargs...))
end

@assignprops(
    HardwareMetadata,
    :manufacturer => manufacturer,
    :model => manufacturer_model_name,
    :serial_number => device_serial_number,
    :extension => dictextension(software_versions,station_name)
)

"""
    HardwareMetadata 


Metadata structure for general MRI sequence information.

## Properties
$(propdoclist(HardwareMetadata))
"""
HardwareMetadata
