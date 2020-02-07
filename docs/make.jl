using Documenter, NeuroCore

makedocs(;
    modules=[NeuroCore],
    format=Documenter.HTML(),
    pages=[
        "Introduction" => "index.md",
        "Imaging" => "imaging_metadata.md",
        "Electrophysiology" => "electrophysiology.md",
        "Semantic Positions" => "semantic_positions.md",
        "Orientation and Dimensions" => "dimensions.md",
        "Units" => "units.md",
        "Types" => "types.md",
    ],
    repo="https://github.com/JuliaNeuroscience/NeuroCore.jl/blob/{commit}{path}#L{line}",
    sitename="NeuroCore.jl",
    authors="Zachary P. Christensen",
)

deploydocs(
    repo = "github.com/JuliaNeuroscience/NeuroCore.jl.git",
)


