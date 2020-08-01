

using NeuroCore.NeuroMetadata: ContrastIngredient

using NeuroCore.AnatomicalAPI

include("contrast_ingredient_tests.jl")
include("encoding_directions.jl")

@testset "Semantic positions" begin
    for (f,vars) in ((AnatomicalAPI.is_left, (:left, :L)),
                     (AnatomicalAPI.is_right, (:right, :R)),
                     (AnatomicalAPI.is_anterior, (:anterior, :A)),
                     (AnatomicalAPI.is_posterior, (:posterior, :P)),
                     (AnatomicalAPI.is_superior, (:superior, :S)),
                     (AnatomicalAPI.is_inferior, (:inferior, :I)),
                     (AnatomicalAPI.is_sagittal, (:sagittal, :left, :L, :right, :R)),
                     (AnatomicalAPI.is_coronal, (:coronal, :anterior, :A, :posterior, :P)),
                     (AnatomicalAPI.is_axial, (:axial, :superior, :S, :inferior, :I)),
                     (AnatomicalAPI.is_white_matter, (:white_matter,)),
                     (AnatomicalAPI.is_gyrus, (:gyrus,)),
                     (AnatomicalAPI.is_cortical, (:cortical,)),
                     (AnatomicalAPI.is_sulcus, (:sulcus,)),
                     #(AnatomicalAPI.is_csp, (:csp,)),
                    )
        for v in vars
            @test @inferred(f(v))
        end
    end
end



