
using NeuroCore.SemanticPositions

@testset "Semantic positions" begin
    for (f,vars) in ((is_left, (:left, :L)),
                     (is_right, (:right, :R)),
                     (is_anterior, (:anterior, :A)),
                     (is_posterior, (:posterior, :P)),
                     (is_superior, (:superior, :S)),
                     (is_inferior, (:inferior, :I)),
                     (is_sagittal, (:sagittal, :left, :L, :right, :R)),
                     (is_coronal, (:coronal, :anterior, :A, :posterior, :P)),
                     (is_axial, (:axial, :superior, :S, :inferior, :I)),
                     (is_white_matter, (:white_matter,)),
                     (is_gyrus, (:gyrus,)),
                     (is_cortical, (:cortical,)),
                     (is_sulcus, (:sulcus,)),
                     (is_csp, (:csp,)),
                    )
        for v in vars
            @test @inferred(f(v))
        end
    end
end


img = NAPArray(ones(2,2), sagittal=1:2, time=1:2)
@test @inferred(is_anatomical(img))

