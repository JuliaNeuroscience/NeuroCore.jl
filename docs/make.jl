using Documenter, NeuroCore

makedocs(;
    modules=[NeuroCore],
    format=Documenter.HTML(),
    pages=[
        "Introduction" => "index.md",
        "Imaging Metadata" => "imaging_metadata.md",
    ],
    repo="https://github.com/JuliaNeuroscience/NeuroCore.jl/blob/{commit}{path}#L{line}",
    sitename="NeuroCore.jl",
    authors="Zachary P. Christensen",
)

deploydocs(
    repo = "github.com/JuliaNeuroscience/NeuroCore.jl.git",
)

