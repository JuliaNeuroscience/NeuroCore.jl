
"""
    is_electrophysiology(::T) -> Bool

Returns `true` if `T` represents electrophysiology data.
"""
is_electrophysiology(::T) where {T} = is_electrophysiology(T)
is_electrophysiology(::Type{T}) where {T} = false

"""
    is_anatomical(::T) -> Bool

Returns `true` if `T` represents anatomical data.
"""
is_anatomical(::T) where {T} = is_anatomical(T)
is_anatomical(::Type{T}) where {T} = false

"""
    is_functional(::T) -> Bool

Returns `true` if `T` represents functional data.
"""
is_functional(::T) where {T} = is_functional(T)
is_functional(::Type{T}) where {T} = false
