_default_getter_def(property_name::String) = "Returns the `$(property_name)` property of `x`."
_default_setter_def(property_name::String) = "Sets the `$(property_name)` property of `x` to `val`."

function compose_definition(method_string, method_def, property_def)
    return string(method_string, "\n\n", method_def, "\n\n", property_def)
end
function compose_definition(method_string, method_def, ::Nothing)
    return string(method_string, "\n\n", method_def)
end

function compose_getter_string(method_name::Symbol, ::Type{T}) where {T}
    return string(method_name, "(x) -> ", T)
end
compose_getter_string(method_name::Symbol, ::Function) = string("\t\t", method_name, "(x)")

compose_setter_string(method_name::Symbol) = string("\t\t", method_name, "(x)")

function neuroproperty(
    getter::Symbol,
    property_name::String,
    default_type,
    default_value;
    setter=Symbol(getter, :!),
    getter_def=_default_getter_def(property_name),
    setter_def=_default_setter_def(property_name),
    property_def=nothing,
    dicom_tag=nothing,
    priority=nothing
   )
    return _neuroproperty(
        getter,
        setter,
        property_name,
        default_type,
        default_value,
        compose_definition(compose_getter_string(getter, default_type), getter_def, property_def),
        compose_definition(compose_setter_string(setter), setter_def, property_def),
        dicom_tag,
        priority
       )
end


function _neuroproperty(
    getter,
    setter,
    property_name,
    default_type,
    default_value,
    getter_doc,
    setter_doc,
    dicom_tag,
    priority
   )
    _getter = Symbol(:_, getter)
    _setter = Symbol(:_, setter)

    check_val = Symbol(:check_, getter)

    @eval begin
        $check_val(x, val) = NeuroCore.check_type(x, $default_type, val, $default_value)

        @doc $getter_doc $getter(x) = $check_val(x, $_getter(ImageCore.HasProperties(x), x))
        $getter(x::AbstractDict{String}) = $check_val(x, get(x, $property_name, NeuroCore.MProperty))

        $_getter(::ImageCore.HasProperties{false}, x) = NeuroCore.MProperty
        $_getter(::ImageCore.HasProperties{true}, x) = get(properties(x), $property_name, NeuroCore.MProperty)

        @doc $setter_doc $setter(x, val) = $_setter(ImageCore.HasProperties(x), x, $check_val(x, val))
        $setter(x) = $_setter(ImageCore.HasProperties(x), x, $check_val(x, NeuroCore.MProperty))
        $setter(x::AbstractDict{String}) = setindex!(x, $check_val(x, NeuroCore.MProperty), $property_name)

        $setter(x::AbstractDict{String}, val) = setindex!(x, $check_val(x, val), $property_name)

        $_setter(::ImageCore.HasProperties{false}, x, val) = NeuroCore.setter_error(x, $property_name)
        $_setter(::ImageCore.HasProperties{true}, x, val) = setindex!(properties(x), val, $property_name)
    end

    #=
    tog = Symbol("typeof($getter)")

    if !isnothing(dicom_tag)
        @eval begin
            dicom_tag(::$tog) = $dicom_tag
        end
    end
    =#
end

function axes_property()
end
