###
### Instution
###
"""
    institution_name(x) -> String

Returns the name of the institution in charge of the equipment that produced the
composite instances.
"""
institution_name(x) = getter(x, "InstitutionName", String, x -> "")

"""
    institution_name!(x, val)

Sets the name of the institution in charge of the equipment that produced the
composite instances.
"""
institution_name!(x, val) = setter!(x, "InstitutionName", String, val)

"""
    institution_address(x) -> String

Return the address of the institution in charge of the equipment that produced
the composite instances.
"""
institution_address(x) = getter(x, "InstitutionAddress", String, x -> "")

"""
    institution_address!(x, val)

Set the address of the institution in charge of the equipment that produced the
composite instances.
"""
institution_address!(x, val) = setter!(x, "InstitutionAddress", String, val)

"""
    institutional_department_name(x) -> String

Return the department in the institution in charge of the equipment that produced
the composite instances.
"""
institutional_department_name(x) = getter(x, "InstitutionalDepartmentName", String, x -> "")

"""
    institutional_department_name!(x, val)

Sets the department in the institution in charge of the equipment that produced
the composite instances.
"""
institutional_department_name!(x, val) = setter!(x, "InstitutionalDepartmentName", String, val)

"""
    station_name(x) -> String

Returns the institution defined name of the machine that produced the composite instances.
"""
station_name(x) = getter(x, "StationName", String, x -> "")

"""
    station_name!(x, val)

Returns the institution defined name of the machine that produced the composite instances.
"""
station_name!(x, val) = setter!(x, "StationName", String, val)
