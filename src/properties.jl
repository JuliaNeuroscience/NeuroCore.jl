struct MissingProperty end
const MProperty = MissingProperty()

check_type(x, ptype, ::MissingProperty, default) = _to_type(x, ptype, default)
check_type(x, ptype, val, default) = _to_type(x, ptype, val)

_to_type(x, ptype::Function, val::Function) = __to_type(ptype(x), val(x))
_to_type(x, ptype::Function, val) = __to_type(ptype(x), val)
_to_type(x, ::Type{T}, val::Function) where {T} = __to_type(T, val(x))
_to_type(x, ::Type{T}, val) where {T} = __to_type(T, val)
__to_type(::Type{T}, val) where {T} = val isa T ? val : T(val)::T

function setter_error(x, pname)
    error("$(typeof(x)) does not have `properties` method. Cannot set $(pname) property.")
end

"""
    getter(x, pname, ptype, pdef)

Provides a type stable interface to retreiving properties from the properties of `x`.

* `x::Any`: Any object that may or may not have properties as defined in `ImageCore.jl`.
* `pname::Symbol`: The property name that should be searched for in `x`'s properties.
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

julia> p = Dict{Symbol,Any}()

julia> new_property(p)
"nothing"

julia> p["new_property"] = "not nothing"

julia> new_property(p)
"not nothing"
```
"""
@inline getter(x, pname, ptype, pdef) = _pre_getter(HasProperties(x), x, pname, ptype, pdef)
@inline getter(x::AbstractDict, pname, ptype, pdef) = check_type(x, ptype, _getter(x, pname), pdef)
_pre_getter(::HasProperties{true}, x, pname, ptype, pdef) = check_type(x, ptype, _getter(properties(x), pname), pdef)
_pre_getter(::HasProperties{false}, x, pname, ptype, pdef) = check_type(x, ptype, MProperty, pdef)
_getter(x, pname) = get(x, pname, MProperty)


"""
    setter!(x, pname, ptype, val)

Provides a type stable interface to setting the properties the properties of `x`.

* `x::Any`: Any object that may or may not have properties as defined in `ImageCore.jl`.
* `pname::Symbol`: The property name that should be searched for in `x`'s properties.
* `ptype::Union{Function,Type}`: If `pytype` is a `Type` then `val` is ensured to
  be a subtype of this. If `ptype` is a `Function` then `ptype(x)` is called
  to determine the appropriate `Type` the `val` should be a subtype of.
* `val`: The value that the property `pname` is set to.

# Examples
```
julia> new_property!(x, val) = setter!(x, "new_property", String, val)

julia> p = Dict{Symbol,Any}()

julia> new_property(p, "not nothing")

julia> p["new_property"]
"not nothing"
```
"""
@inline setter!(x, pname, ptype, val) = _pre_setter!(HasProperties(x), x, pname, ptype, val)
setter!(x::AbstractDict, pname, ptype, val) = setindex!(x, _to_type(x, ptype, val), pname)
_pre_setter!(::HasProperties{true}, x, pname, ptype, val) = setindex!(properties(x), _to_type(x, ptype, val), pname)
_pre_setter!(::HasProperties{false}, x, pname, ptype, pdef) = setter_error(x, pname)
