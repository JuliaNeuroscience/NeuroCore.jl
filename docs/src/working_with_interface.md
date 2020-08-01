# Interfacing With NeuroCore

The most important component of the NeuroCore interface is just an array type that has a predictable way of identifying important features and is compatible with well established libraries for composing algorithms.
Therefore, the easiest way to use data structures that are compatible with the NeuroCore interface is to just use already supported array types. This doesn't prevent developers from creating their own compatible array types or simply taking advantage of Julia's multiple dispatch to exclusively interface with those methods needed.

## Using Existing Array Types

The fully supported array types used in NeuroCore are derived from the `AxisIndices` package and are as follows...

* `AxisArray`
* `NamedAxisArray`
* `MetaAxisArray`
* `NamedMetaAxisArray`

...and here's a quick guide to the prefixes.

* `Axis`: supports fancy indexing
* `Named`: supports named dimensions
* `Meta`: supports array level metadata 

The `NamedMetaAxisArray` type provides all the functionality that the other types do, so we'll be using it for most examples. Just be aware that the interface should be the same between each of these types where it makes sense (e.g., `NamedAxisArray` and `NamedMetaAxisArray` both use `dimnames` to return dimension names).

### From IO Streams to Arrays

The only information necessary for composing a new `NamedMetaAxisArray` are the dimension names, axes, and metadata.
For example, let's say we have a 2-dimensional image of the brain in the coronal view and it is read into memory by a special streaming type `CoronalStream`.
We'll assume that we know the dimension names are "sagittal" and "axial", each axis is 50 millimeters long with 50 pixels, and we just want a simply `Int` type.
We'll keep the metadata simple for know and only specify the institution name. Now let's use several different methods for composing our array.

```julia
using NeuroCore

using Unitful: mm

function NeuroCore.NamedMetaAxisArray(s::CoronalStream)
    return NamedMetaAxisArray{(:sagittal, :axial)}(  # dimension names specified first as part of the type
        read!(s, Array{Int}(undef, (50, 50))),       # Read a standard array in
        (range(1, stop=50)mm, range(1, stop=50)mm),  # 
        institution_name = "some institution"        # metadata specified by key word
    )
end
```

We could make this a lot more composable by breaking it down to the core components that
make up the type though.

```julia
NeuroCore.dimnames(::Type{<:CoronalStream}) = (:sagittal, :axial)

NeuroCore.axes(s::CoronalStream) = (range(1, stop=50)mm, range(1, stop=50)mm)

NeuroCore.metadata(s::CoronalStream) = Dict{Symbol,Any}(institution_name => "some institution")

Base.eltype(::Type{<:CoronalStream) = Int

function NamedMetaAxisArray(x::CoronalStream)
    T = eltype(x)
    coronal_stream_axes = axes(x)
    A = AxisArray{T}(undef, coronal_stream_axes)
    read!(s, A)
    return NamedMetaAxisArray{dimnames(s)}(A, metadata=metadata(s))
end
```

Note that the metadata is a reserved keyword for providing the collection of metadata
Also note that metadata is expected to have a `Symbol` type as its keys.
This allows metadata to be accessed like properties (e.g., `array_instance.institution_name`)

## Using Other Array-Like Types

If for some reason the structure you want to use is like an array but isn't a subtype of an array (i.e. so you cannot wrap it in a `NamedMetaAxisArray`), then you can piece together whatever functionality you need using something like the following.

```julia
using AxisIndices

using NamedDims

NamedDims.dimnames(::Type{<:MatrixType}) = (:dim1_name, :dim2_name)

AxisIndices.metadata(x::MatrixType) = getfield(x, :metadata)

Base.parent(x::MatrixType) = getfield(x, :parent)

Base.@propagate_inbounds function Base.getindex(x::MatrixType, arg1::Int, arg2::Int)
    return getindex(parent(x), arg1, arg2)
end

Base.@propagate_inbounds function Base.getindex(x::MatrixType, arg1, arg2)
    return getindex(
        x,
        AxisIndices.to_index(axes(x, 1), arg1),
        AxisIndices.to_index(axes(x, 2), arg2)
    )
end

Base.@propagate_inbounds function Base.getindex(x::MatrixType; kwargs...)
    inds = NamedDims.order_named_inds(x; kwargs...)
    return getindex(x, inds...)
end

Base.getproperty(x::MatrixType, s::Symbol) = getproperty(metadata(x), s)

Base.setproperty!(x::MatrixType, s::Symbol, val) = setproperty!(metadata(x), s, val)

Base.propertynames(x::MatrixType) = propertynames(metadata(x))
```

Let's run through this by each feature we're trying to support.
1. Named dimensions: We need to be able to extract this with `dimnames`. In order to get nice named indexing we have to provide a version of getindex that uses keyword arguments.
  This won't provide named dimension interfaces for other functions (e.g., permutedims, etc.).
  Each of these must be overloaded individually for the new type.
2. Fancy indexing: accomplished through conversion of arguments at each axis via `AxisIndices.to_index`.
  This gets more involved if supporting arbitrary dimensions.
3. Metadata: Main component is `AxisIndices.metadata`.
  The last 3 lines allow metadata to be treated like properties.
  Note that if you do this fields cannot be accessed like properties.
  For example, we assume that `MatrixType` wraps a parent structure but this cannot be accessed via `MatrixType.parent` anymore.


In addition to consulting the documentation for `NamedDims` or `AxisIndices`, users may be
interested in Julia's documentation of the [array interface](https://docs.julialang.org/en/v1/manual/interfaces/#man-interface-array-1).

## Overload Important Methods

Up to this point we've assumed that everything is an array or array-like.
However, the same principles broadly apply to other data structures.
For example, a structural connectome may be stored as an unordered collection of vectors of points.
In this case the relation between the first and second fiber stored may have no spatial relationship.
However, we can still use `Base.axes`, `NamedDims.dimnames`, etc. to provide information about the spatial orientation.


```julia
struct Fibers{L,Axs}
    fibers::Vector{Vector{Point3f0}}
    axes::NamedTuple{L,Axs}
end

NeuroCore.dimnames(::Type{<:Fibers{L,Axs}}) where {L,Axs} = L

Base.axes(f::Fibers) = values(getfield(f, :axes))
```

This alone provides compatibility with most methods in `NeuroCore.SpatialAPI` and `NeuroCore.AnatomicalAPI`.

