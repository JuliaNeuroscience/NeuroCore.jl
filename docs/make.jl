using Documenter, NeuroCore

makedocs(;
    modules=[NeuroCore],
    format=Documenter.HTML(),
    pages=[
        "Introduction" => "index.md",
        "Properties" => [
            "Introduction to Properties" => "introduction_properties.md",
            "Imaging" => "imaging_metadata.md",
            "Electrophysiology" => "electrophysiology.md",
        ],
        "Anatomical API" => "anatomical_api.md",
        "Spatial API" => "spatial_api.md",  # TODO
        "Color Channels" => "color_channels.md",  # TODO
        "Types" => "types.md",
    ],
    repo="https://github.com/JuliaNeuroscience/NeuroCore.jl/blob/{commit}{path}#L{line}",
    sitename="NeuroCore.jl",
    authors="Zachary P. Christensen",
)

deploydocs(
    repo = "github.com/JuliaNeuroscience/NeuroCore.jl.git",
)


