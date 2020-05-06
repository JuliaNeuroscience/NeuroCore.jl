
"""
    institution_name(x)
    institution_name!(x, val)

Name of the institution in charge of the equipment that produced the composite instances.
"""
@defprop InstitutionName{:institution_name}::String

"""
    institutional_department_name(x)
    institutional_department_name!(x, val)

The department in the institution in charge of the equipment that produced the composite instances.
"""
@defprop InstitutionalDepartmentName{:institutional_department_name}::String

"""
    institution_address(x)
    institution_address!(x, val)

The address of the institution in charge of the equipment that produced the composite instances.
"""
@defprop InstitutionAddress{:institution_address}::String

"""
    InstitutionInformation 

Metadata structure for general MRI sequence information.

## Supported Properties

$(description_list(institution_name,institutional_department_name,institution_address))

## Examples
```jldoctest
julia> using NeuroCore

julia> m = InstitutionInformation("a", "b", "c")
InstitutionInformation("a", "b", "c")

julia> m.institution_name
"a"

julia> m.institution_address
"c"

julia> m.institutional_department_name
"b"
```
"""
struct InstitutionInformation
    name::String
    department::String
    address::String
end

@properties InstitutionInformation begin
    institution_name(self) => :name
    institutional_department_name(self) => :department
    institution_address(self) => :address
end

