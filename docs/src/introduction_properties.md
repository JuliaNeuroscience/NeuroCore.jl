# Introduction to Properties

## What are properties?

NeuroCore uses properties (as defined in [FieldProperties.jl](https://github.com/Tokazama/FieldProperties.jl)) for the majority of its API. This means that most properties in this package have a way of retrieving, setting, and enforcing type stability for each property (anything defined using the macro `@defprop`). For example, `epoch_length(x)`'s default behavior is to call `getproperty(x, :epoch_length)` and `epoch_length!(x, val)`'s default behavior is to call `setproperty!(x, :epoch_length, val)`. Therefore, any given type can use this method by simply defining a field named `epoch_length`. Details on the order of calls, enforcing certain return types, and documenting properties is further defined in the [FieldProperties.jl](https://github.com/Tokazama/FieldProperties.jl)) documentation.

## Why use properties?

Instead of pursuing a single data structure that everyone else conforms to, NeuroCore allows for any data structure as long as the return type of a given method is consistent. This solution is much more tenable than enforcing a limited set of structures, which would require continually changes to structures in order to meet the needs of an evolving field. For example, there are many neurophysiology file formats. Numerous efforts to form a universal standard have yet to be fully adopted in the neuroscience community. Using NeuroCore allows users to have a consistent API right now and developers the flexibility of optimizing hardware and file formats over time. Therefore, NeuroCore only attempts to enforce:

1. Types for core data (see [NeuroCore Types](@ref))
2. Types for individual pieces of metadata (aka properties)

This leaves the organization of metadata up to the discretion of package authors. Although there are a number of metadata types provided, they mainly serve as a convenient way to store a number of related properties and do not represent a strict guideline on how to organize metadata.


## Why _these_ properties?

The majority of properties were defined and documented using the definitions provided from the [Brain Imaging Data Structures (BIDS)](https://bids.neuroimaging.io/) standard. This allowed the use of nomenclature that had already been agreed upon by individuals from multiple fields and has already been adopted by a significant portion of the neuroscience community. Similar to the BIDS standard, this package is not restricted to the topic of brain imaging. Unlike BIDS, this package does not focus on neuroscience related ontology outside of its pragmatic application to computational tools.

