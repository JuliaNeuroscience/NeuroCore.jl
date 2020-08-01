
# Infrastructure for value transformation

"""
    clamp01(x) -> y

Produce a value `y` that lies between 0 and 1, and equal to `x` when
`x` is already in this range. Equivalent to `clamp(x, 0, 1)` for
numeric values. For colors, this function is applied to each color
channel separately.

See also: [`clamp01!`](@ref), [`clamp01nan`](@ref).
"""
clamp01(x::Union{N0f8,N0f16}) = x
clamp01(x::Number) = clamp(x, zero(x), oneunit(x))
clamp01(c::Colorant) = mapc(clamp01, c)

"""
    clamp01!(array::AbstractArray)

Restrict values in array to [0, 1], in-place. See also [`clamp01`](@ref).
"""
function clamp01!(img::AbstractArray)
    # slgihtly faster than map!(clamp01, img, img)
    @inbounds for i in eachindex(img)
        img[i] = clamp01(img[i])
    end
    return img
end

"""
    clamp01nan(x) -> y

Similar to `clamp01`, except that any `NaN` values are changed to 0.

See also: [`clamp01nan!`](@ref), [`clamp01`](@ref).
"""
clamp01nan(x) = clamp01(x)
clamp01nan(x::AbstractFloat) = ifelse(isnan(x), zero(x), clamp01(x))
clamp01nan(c::Colorant) = mapc(clamp01nan, c)

"""
    clamp01nan!(array::AbstractArray)

Similar to `clamp01!`, except that any `NaN` values are changed to 0.

See also: [`clamp01!`](@ref), [`clamp01nan`](@ref)
"""
function clamp01nan!(img::GenericImage)
    # slgihtly faster than map!(clamp01nan, img, img)
    @inbounds for i in eachindex(img)
        img[i] = clamp01nan(img[i])
    end
    return img
end

"""
    scale_minmax(min, max) -> f
    scale_minmax(T, min, max) -> f

Return a function `f` which maps values less than or equal to `min` to
0, values greater than or equal to `max` to 1, and uses a linear scale
in between. `min` and `max` should be real values.

Optionally specify the return type `T`. If `T` is a colorant (e.g.,
RGB), then scaling is applied to each color channel.

# Examples

## Example 1

```julia
julia> f = scale_minmax(-10, 10)
(::#9) (generic function with 1 method)

julia> f(10)
1.0

julia> f(-10)
0.0

julia> f(5)
0.75
```

## Example 2

```julia
julia> c = RGB(255.0,128.0,0.0)
RGB{Float64}(255.0,128.0,0.0)

julia> f = scale_minmax(RGB, 0, 255)
(::#13) (generic function with 1 method)

julia> f(c)
RGB{Float64}(1.0,0.5019607843137255,0.0)
```

See also: [`take_map`](@ref).
"""
function scale_minmax(min::T, max::T) where T
    @inline function(x)
        xp, minp, maxp = promote(x, min, max)  # improves performance to promote explicitly
        y = clamp(xp, minp, maxp)
        (y-minp)/(maxp-minp)
    end
end
function scale_minmax(::Type{Tout}, min::T, max::T) where {Tout,T}
    @inline function(x)
        xp, minp, maxp = promote(x, min, max)
        y = clamp(xp, minp, maxp)
        smmconvert(Tout, (y-minp)/(maxp-minp))
    end
end
@inline smmconvert(::Type{Tout}, x) where {Tout} = convert(Tout, x)
# since we know the result will be between 0 and 1, we can use rem to save a check
@inline smmconvert(::Type{Tout}, x) where {Tout<:Normed} = rem(x, Tout)

scale_minmax(min, max) = scale_minmax(promote(min, max)...)
scale_minmax(::Type{T}, min, max) where {T} = scale_minmax(T, promote(min, max)...)

# TODO: use triangular dispatch when we can count on Julia 0.6+
function scale_minmax(::Type{C}, min::T, max::T) where {C<:Colorant, T<:Real}
    return _scale_minmax(C, eltype(C), min, max)
end
function _scale_minmax(::Type{C}, ::Type{TC}, min::T, max::T) where {C<:Colorant, TC<:Real, T<:Real}
    freal = scale_minmax(TC, min, max)
    @inline function(c)
        C(mapc(freal, c))
    end
end
function _scale_minmax(::Type{C}, ::Type{Any}, min::T, max::T) where {C<:Colorant, T<:Real}
    freal = scale_minmax(min, max)
    @inline function(c)
        C(mapc(freal, c))
    end
end

"""
    scale_signed(maxabs) -> f

Return a function `f` which scales values in the range `[-maxabs,
maxabs]` (clamping values that lie outside this range) to the range
`[-1, 1]`.

See also: [`color_signed`](@ref).
"""
function scale_signed(maxabs::Real)
    maxabs > 0 || throw(ArgumentError("maxabs must be positive, got $maxabs"))
    return x -> clamp(x, -maxabs, maxabs)/maxabs
end

"""
    scale_signed(min, center, max) -> f

Return a function `f` which scales values in the range `[min, center]`
to `[-1,0]` and `[center,max]` to `[0,1]`. Values smaller than
`min`/`max` get clamped to `min`/`max`, respectively.

See also: [`color_signed`](@ref).
"""
function scale_signed(min::T, center::T, max::T) where T<:Real
    min <= center <= max || throw(ArgumentError("values must be ordered, got $min, $center, $max"))
    sneg, spos = 1/(center-min), 1/(max-center)
    function(x)
        Δy = clamp(x, min, max) - center
        ifelse(Δy < 0, sneg*Δy, spos*Δy)
    end
end
function scale_signed(min::Real, center::Real, max::Real)
    return scale_signed(promote(min, center, max)...)
end

"""
    color_signed()
    color_signed(colorneg, colorpos) -> f
    color_signed(colorneg, colorcenter, colorpos) -> f

Define a function that maps negative values (in the range [-1,0]) to
the linear colormap between `colorneg` and `colorcenter`, and positive
values (in the range [0,1]) to the linear colormap between
`colorcenter` and `colorpos`.

The default colors are:

- `colorcenter`: white
- `colorneg`: green1
- `colorpos`: magenta

See also: [`scale_signed`](@ref).
"""
color_signed(neg::C, center::C, pos::C) where {C<:Colorant} = function(x)
    y = clamp(x, -oneunit(x), oneunit(x))
    yabs = abs(y)
    C(ifelse(y>0, weighted_color_mean(yabs, pos, center),
                  weighted_color_mean(yabs, neg, center)))
end

function color_signed(colorneg::C, colorpos::C) where C<:Colorant
    return color_signed(colorneg, C(colorant"white"), colorpos)
end

color_signed() = color_signed(colorant"green1", colorant"magenta")


"""
    take_map(f, A) -> fnew
    take_map(f, T, A) -> fnew

Given a value-mapping function `f` and an array `A`, return a
"concrete" mapping function `fnew`. When applied to elements of `A`,
`fnew` should return valid values for storage or display, for example
in the range from 0 to 1 (for grayscale) or valid colorants. `fnew`
may be adapted to the actual values present in `A`, and may not
produce valid values for any inputs not in `A`.

Optionally one can specify the output type `T` that `fnew` should produce.

# Example:
```julia
julia> A = [0, 1, 1000];

julia> f = take_map(scale_minmax, A)
(::#7) (generic function with 1 method)

julia> f.(A)
3-element Array{Float64,1}:
 0.0
 0.001
 1.0
```
"""
take_map

take_map(f, A) = f
take_map(f, ::Type{T}, A) where {T} = x->T(f(x))

function take_map(::typeof(scale_minmax), A::AbstractArray{T}) where T<:Real
    min, max = extrema(A)
    scale_minmax(min, max)
end
function take_map(::typeof(scale_minmax), A::AbstractArray{C}) where C<:Colorant
    min, max = extrema(channel_view(A))
    scale_minmax(C, min, max)
end
function take_map(::typeof(scale_minmax), ::Type{Tout}, A::AbstractArray{T}) where {Tout,T<:Real}
    min, max = extrema(A)
    scale_minmax(Tout, min, max)
end
function take_map(::typeof(scale_minmax), ::Type{Cout}, A::AbstractArray{C}) where {Cout<:Colorant,C<:Colorant}
    min, max = extrema(channel_view(A))
    scale_minmax(Cout, min, max)
end

function take_map(::typeof(scale_signed), A::AbstractArray{T}) where T<:Real
    mn, mx = extrema(A)
    scale_signed(max(abs(mn), abs(mx)))
end

