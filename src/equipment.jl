"""
The manufacturer of the equipment that produced the composite instances.
"""
@defprop Manufacturer{:manufacturer}::String

"""
The manufacturer's model name of the equipment that produced the composite instances.
"""
@defprop ManufacturerModelName{:manufacturer_model_name}::String

"""
The serial number of the equipment that produced the composite instances. A
pseudonym can also be used to prevent the equipment from being identifiable,
so long as each pseudonym is unique within the dataset.
"""
@defprop DeviceSerialNumber{:device_serial_number}::String

"""
The manufacturer’s designation of software version of the equipment that
produced the composite instances.
"""
@defprop SoftwareVersions{:software_versions}::String

"""
Name of the institution in charge of the equipment that produced the composite
instances.
"""
@defprop InstitutionName{:institution_name}::String

"""
The department in the institution in charge of the equipment that produced
the composite instances.
"""
@defprop InstitutionalDepartmentName{:institutional_department_name}::String

"""
The address of the institution in charge of the equipment that produced the
composite instances.
"""
@defprop InstitutionAddress{:institution_address}::String

"""
Institution defined name of the machine that produced the composite instances.
"""
@defprop StationName{:station_name}::String

"""
Freeform description of the observed subject artefact and its possible cause (e.g.,
"door open", "nurse walked into room at 2 min", "seizure at 10 min"). If this
field is left empty, it will be interpreted as absence of artifacts.
"""
@defprop ArtefactDescription{:artefact_description}::String

