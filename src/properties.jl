# flip_angle - dicom_tag = (0x0018,0x1314)
# contrast_bolus_ingredient (0x0018,0x1048)
# sequence_name - dicom_tag=(0x0018,0x0024)
# scanning_sequence - dicom_tag=(0x0018, 0x0020)
# sequence_variant - dicom_tag=(0x0018,0x0021)
# manufacturer - dicom_tag=(0x0008, 0x0070)
# manufacturer_model_name - dicom_tag=(0x0008, 0x1090)
# device_serial_number - dicom_tag = (0x0018, 0x1000)
# software_versions - dicomtag(::typeof(software_versions)) = (0x0018, 0x1020)
# magnetic_field_strength - dicom_tag=(0x0018,0x0087)
# receiver_coil_name - dicom_tag=(0x0018, 0x1250)
# institution_name - dicom_tag = (0x0008,0x0080)
# institution_address - dicom_tag = (0x0008,0x0081)
# institutional_department_name - dicom_tag=(0x0008,0x1040)
# station_name - dicom_tag=(0x0008, 0x1010)


neuroproperty(:freqdim, "FrequencyDimension", Int, 0)

"""
    negative_contrast -> Bool
"""
function negative_contrast end
#json_tag(::typeof(negative_contrast)) = "NegativeContrast"

# TODO contrast_bolus_ingredient
"""
    contrast_bolus_ingredient(x) = ""

Active ingredient of agent. Values MUST be one of: IODINE, GADOLINIUM,
CARBON DIOXIDE, BARIUM, XENON.
"""
contrast_bolus_ingredient(x::Any) = ""

json_tag(::typeof(contrast_bolus_ingredient)) = "ContrastBolusIngredient"

#= TODO
Name	contrast_label	Description
BOLD	bold	Blood-Oxygen-Level Dependent contrast (specialized T2* weighting)
CBV	cbv	Cerebral Blood Volume contrast (specialized T2* weighting or difference between T1 weighted images)
Phase	phase	Phase information associated with magnitude information stored in BOLD contrast
=#


_caltype(x::AbstractArray{T}) where {T} = T
_caltype(x::Any) = Float64
_calmin(x::AbstractArray) = minimum(x)
_calmax(x::AbstractArray) = maximum(x)
_calmin(x::Any) = one(Float64)
_calmax(x::Any) = one(Float64)
