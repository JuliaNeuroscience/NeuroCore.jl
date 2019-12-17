# TODO these are dicom tags accompnying formal properties
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
# dwell_time - dicom_tag=(0x0019, 0x1018)
# echo_time - dicom_tag=(0x0018, 0x0081)
# inversion_time - dicom_tag=(0x0018, 0x0082)
# repitition_time - dicom_tag=(0x0018,0x0080)
# acqduration - dicom_tag=(0x0018, 0x9073)


struct MissingProperty end
const MProperty = MissingProperty()

check_type(x, f, val, default) where {X} = _check_type(x, f, val)
check_type(x, f, ::MissingProperty, default) = _check_type(x, f, default)

_check_type(x, f::Function, default) = __check_type(x, f(x), default)
_check_type(x, ::Type{T}, default) where {T}= __check_type(x, T, default)
__check_type(x, ::Type{T}, f::Function) where {T} = __check_type(x, T, f(x))
__check_type(x, ::Type{T}, val) where {T} = val isa T ? val : T(val)::T

function setter_error(x, pname)
    error("$(typeof(x)) does not have `properties` method. Cannot set $(pname) property.")
end

"""
    getter(x, pname, ptype, pdef)

Provides a type stable interface to retreiving properties from the properties of `x`.

* `x::Any`: Any object that may or may not have properties as defined in `ImageCore.jl`.
* `pname::String`: The property name that should be searched for in `x`'s properties.
* `ptype::Union{Function,Type}`: If `pytype` is a `Type` then whatever is returned
  is first converted to this type. If `ptype` is a `Function` then `ptype(x)` is called
  to determine the appropriate return type.
* `pdef::Union{Function,Any}`: If `pdef` determines the defaul that is returned if
  `pname` is not found in the properties of `x` or if `x` has no properties. If `pdef`
  is a function then `pdef(x)` is called to reach the default returned value. Otherwise,
  `pdef` is returned. The default value should be consistent with what is defined by
  `ptype`.

# Examples
```
julia> new_property(x) = getter(x, "new_property", String, x -> "nothing")

julia> p = Dict{String,Any}()

julia> new_property(p)
"nothing"

julia> p["new_property"] = "not nothing"

julia> new_property(p)
"not nothing"
```
"""
getter(x, pname, ptype, pdef) = _pre_getter(HasProperties(x), x, pname, ptype, pdef)
getter(x::AbstractDict, pname, ptype, pdef) = check_type(x, ptype, _getter(x, pname), pdef)
_pre_getter(::HasProperties{true}, x, pname, ptype, pdef) = check_type(x, ptype, _getter(properties(x), pname), pdef)
_pre_getter(::HasProperties{false}, x, pname, ptype, pdef) = check_type(x, f, MProperty, pdef)
_getter(x, pname) = get(x, pname, MProperty)


"""
    setter!(x, pname, ptype, val)

Provides a type stable interface to setting the properties the properties of `x`.

* `x::Any`: Any object that may or may not have properties as defined in `ImageCore.jl`.
* `pname::String`: The property name that should be searched for in `x`'s properties.
* `ptype::Union{Function,Type}`: If `pytype` is a `Type` then `val` is ensured to
  be a subtype of this. If `ptype` is a `Function` then `ptype(x)` is called
  to determine the appropriate `Type` the `val` should be a subtype of.
* `val`: The value that the property `pname` is set to.

# Examples
```
julia> new_property!(x, val) = setter!(x, "new_property", String, val)

julia> p = Dict{String,Any}()

julia> new_property(p, "not nothing")

julia> p["new_property"]
"not nothing"
```
"""
setter!(x, pname, ptype, val) = _pre_setter!(HasProperties(x), x, pname, ptype, val)
setter!(x::AbstractDict, pname, ptype, pdef) = setindex!(x, _check_type(x, ptype, val, pdef), pname)
_pre_setter!(::HasProperties{true}, x, pname, ptype, val) = setindex!(x, _check_type(x, ptype, val), pname)
_pre_setter!(::HasProperties{false}, x, pname, ptype, pdef) = setter_error(x, pname)
