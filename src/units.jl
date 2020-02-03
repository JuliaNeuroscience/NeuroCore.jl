
"""
    second_type(x)

Returns the type used for seconds given `x`.

## Examples
```jldoctest unit_tests
julia> using NeuroCore

julia> second_type(Any)
Unitful.Quantity{Float64,𝐓,Unitful.FreeUnits{(s,),𝐓,nothing}}
```
"""
second_type(x) = typeof(one(Float64) * s)

"""
    tesla_type(x)

Returns the type used for tesla given `x`.

## Examples
```jldoctest unit_tests
julia> using NeuroCore

julia> tesla_type(Any)
Unitful.Quantity{Float64,𝐌*𝐈^-1*𝐓^-2,Unitful.FreeUnits{(T,),𝐌*𝐈^-1*𝐓^-2,nothing}}
```
"""
tesla_type(x) = typeof(one(Float64) * T)

"""
    hertz_type(x)

Returns the type used for hertz given `x`.

## Examples
```jldoctest unit_tests
julia> using NeuroCore

julia> hertz_type(Any)
Unitful.Quantity{Float64,𝐓^-1,Unitful.FreeUnits{(Hz,),𝐓^-1,nothing}}
```
"""
hertz_type(x) = typeof(one(Float64) * Hz)

"""
    degree_type(x)

Returns the type used for hertz given `x`.

## Examples
```jldoctest unit_tests
julia> using NeuroCore

julia> degree_type(Any)
Unitful.Quantity{Int64,NoDims,Unitful.FreeUnits{(°,),NoDims,nothing}}
```
"""
degree_type(x) = typeof(1 * °)

"""
    ohms_type(x)

Returns the type used for ohms given `x`.

## Examples
```jldoctest unit_tests
julia> using NeuroCore

julia> ohms_type(Any)
Unitful.Quantity{Float64,𝐋^2*𝐌*𝐈^-2*𝐓^-3,Unitful.FreeUnits{(kΩ,),𝐋^2*𝐌*𝐈^-2*𝐓^-3,nothing}}
```
"""
ohms_type(x) = typeof(1.0u"kΩ")

