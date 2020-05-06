
"""
    is_radiologic(x) -> Bool

Test to see if `x` is in radiological orientation.
"""
is_radiologic(x) = is_radiologic(spatialorder(x))
function is_radiologic(x::NTuple{3,Symbol})
    return is_left(first(x)) & is_anterior(@inbounds(x[2])) & is_superior(last(x))
end

"""
    is_neurologic(x) -> Bool

Test to see if `x` is in neurological orientation.
"""
is_neurologic(x) = is_neurologic(spatial_order(x))
function is_neurologic(x::NTuple{3,Symbol})
    return is_right(first(x)) & is_anterior(@inbounds(x[2])) & is_superior(last(x))
end

"""
    is_anatomical(x) -> Bool

Returns `true` if `T` represents anatomical data.
"""
@inline function is_anatomical(x)
    if has_sagittaldim(x) 
        return true
    elseif has_axialdim(x)
        return true
    elseif has_coronaldim(x)
        return true
    else
        return false
    end
end

"""
    is_electrophysiology(::T) -> Bool

Returns `true` if `T` represents electrophysiology data.
"""
is_electrophysiology(::T) where {T} = is_electrophysiology(T)
is_electrophysiology(::Type{T}) where {T} = has_channel_axis(T) & has_time_axis(T)


