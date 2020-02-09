# NeuroCore Types

## The NeuroArray

!!! warning

    Although the basic syntax for interacting with a NeuroArray is not expected
    to change, there are numerous efforts underway to simplify and optimizae the
    arrays with named dimensions and special indices. Therefore, some of the
    following documentation may change in the future.

Julia benefits enormously from having a common interface to customizable arrays and using the `AbstractArray` interface instantly allows us access to cutting edge algorithms that would otherwise take months to years to make compatible with neuroscience specific formats. NeuroCore takes ownership over arrays from existing packages (e.g., `ImageMeta` from ImageMetadata) by including a custom metadata field. In so doing we inherit well maintained array structures and can create unique methods when necessary.

The [Orientation and Dimension Names](@ref) section covers unique methods made available through this package for dimensions. The remaining documentation is mostly dedicated to accessing and composing various forms of metadata.

```@docs
NeuroCore.NeuroArray
```

## Coordinates

Sets of coordinates may be created using a vector of tuples through the `NeuroCoordinates` type. This offers the same functionality as a `NeuroArray` for storing unique metadata.

```@docs
NeuroCore.NeuroCoordinates
```

