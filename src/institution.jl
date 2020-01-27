
"Name of the institution in charge of the equipment that produced the composite instances."
@defprop InstitutionName{:institution_name}::String

"The department in the institution in charge of the equipment that produced the composite instances."
@defprop InstitutionalDepartmentName{:institutional_department_name}::String

"The address of the institution in charge of the equipment that produced the composite instances."
@defprop InstitutionAddress{:institution_address}::String

struct InstitutionInformation
    name::String
    department::String
    address::String
end

@assignprops(
    InstitutionInformation,
    :name => institution_name,
    :department => institutional_department_name,
    :address => institution_address
)

"""
    InstitutionInformation 


Metadata structure for general MRI sequence information.

## Properties
$(propdoclist(InstitutionInformation))
"""
InstitutionInformation
