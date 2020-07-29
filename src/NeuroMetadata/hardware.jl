
"""
    manufacturer(x)
    manufacturer!(x, val)

The manufacturer of the equipment that produced the composite instances.
"""
@defprop Manufacturer{:manufacturer}::String

"""
    manufacturer_model_name(x)
    manufacturer_model_name!(x, val)

The manufacturer's model name of the equipment that produced the composite instances.
"""
@defprop ManufacturerModelName{:manufacturer_model_name}::String

"""
    device_serial_number(x)
    device_serial_number!(x, val)

The serial number of the equipment that produced the composite instances. A
pseudonym can also be used to prevent the equipment from being identifiable,
so long as each pseudonym is unique within the dataset.
"""
@defprop DeviceSerialNumber{:device_serial_number}::String


"""
    software_versions(x)
    software_versions!(x, val)

The manufacturer’s designation of software version of the equipment that produced the composite instances.
"""
@defprop SoftwareVersions{:software_versions}::String

"""
    station_name(x)
    station_name!(x, val)

Institution defined name of the machine that produced the composite instances.
"""
@defprop StationName{:station_name}::String

"""
    HardwareMetadata 

Metadata structure for general MRI sequence information.

## Supported Properties
$(description_list(manufacturer, manufacturer_model_name, device_serial_number))

## Examples
```jldoctest
julia> using NeuroCore

julia> m = HardwareMetadata("a", "b", "c");

julia> m.device_serial_number
"c"

julia> m.manufacturer_model_name
"b"

julia> m.manufacturer
"a"
```
"""
struct HardwareMetadata{M} <: AbstractPropertyList{M}
    manufacturer::String
    model::String
    serial_number::String
    extension::M
end

FieldProperties.properties(m::HardwareMetadata) = getfield(m, :extension)

function HardwareMetadata(manufacturer, model, serial_number; kwargs...)
    return HardwareMetadata(manufacturer, model, serial_number, Metadata(; kwargs...))
end

@properties HardwareMetadata begin
    manufacturer(self) => :manufacturer
    manufacturer_model_name(self) => :model
    device_serial_number(self) => :serial_number
    Any(self) => :extension
    Any!(self, val) => :extension
end

