#=
* This is a very minimal implementation along the lines of properties from this:
  http://bioportal.bioontology.org/ontologies/FMA. Instead of defining a complex
  type hierarchy we need to use traits because this will invetiably evolve.

* It might be good adopt something like FilePathsBase.jl and parts of each "path"
  could be subject to these methods/traits.
=#
"""
    is_left(x) -> Bool

Returns `true` if `x` represent the left position.
"""
is_left(x::Symbol) = (x === :left) | (x === :L)

"""
    is_right(x) -> Bool

Returns `true` if `x` represent the right position.
"""
is_right(x::Symbol) = (x === :right) | (x === :R)

"""
    is_anterior(x) -> Bool

Returns `true` if `x` represent the anterior position.
"""
is_anterior(x::Symbol) = (x === :anterior) | (x === :A)

"""
    is_posterior(x) -> Bool

Returns `true` if `x` represent the posterior position.
"""
is_posterior(x::Symbol) = (x === :posterior) | (x === :P)

"""
    is_inferior(x) -> Bool

Returns `true` if `x` represent the inferior position.
"""
is_inferior(x::Symbol) = (x === :inferior) | (x === :I)

"""
    is_superior(x) -> Bool

Returns `true` if `x` represent the superior position.
"""
is_superior(x::Symbol) = (x === :superior) | (x === :S)

"""
    is_sagittal(x) -> Bool

Returns `true` if `x` represent the sagittal orientation.
"""
is_sagittal(x::Symbol) = is_left(x) | is_right(x) | (x === :sagittal)

"""
    is_coronal(x) -> Bool

Returns `true` if `x` represent the coronal orientation.
"""
is_coronal(x::Symbol) = is_anterior(x) | is_posterior(x) | (x === :coronal)

"""
    is_axial(x) -> Bool

Returns `true` if `x` represent the axial orientation.
"""
is_axial(x::Symbol) = is_superior(x) | is_inferior(x) | (x === :axial)

"""
    is_cortical(::T) -> Bool

Returns `true` if `T` represents a cortical region.
"""
is_cortical(x::Symbol) = x === :cortical

"""
    is_csp(::T) -> Bool

Returns `true` if `T` represents a region of corticospinal fluid (CSP).
"""
is_csp(x::Symbol) = x === :csp

"""
    is_white_matter(::T) -> Bool

Returns `true` if `T` represents white matter.
"""
is_white_matter(x::Symbol) = x === :white_matter

"""
    is_gyrus(::T) -> Bool

Returns `true` if `T` represents a gyrus.
"""
is_gyrus(x::Symbol) = x === :gyrus

"""
    is_sulcus(::T) -> Bool

Returns `true` if `T` represents a gyrus.
"""
is_sulcus(x::Symbol) = x === :sulcus

"""
    is_channel(::T) -> Bool

Returns `true` if `T` represents a gyrus.
"""
is_channel(x::Symbol) = x === :channel

