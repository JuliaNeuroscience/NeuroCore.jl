
using NeuroCore:
    is_left,
    is_right,
    is_anterior,
    is_posterior,
    is_superior,
    is_inferior,
    is_sagittal,
    is_axial,
    is_coronal

@testset "Semantic positions" begin
    for (f,vars) in ((is_left, (:left, :L)),
                     (is_right, (:right, :R)),
                     (is_anterior, (:anterior, :A)),
                     (is_posterior, (:posterior, :P)),
                     (is_superior, (:superior, :S)),
                     (is_inferior, (:inferior, :I)),
                     (is_sagittal, (:sagittal, :left, :L, :right, :R)),
                     (is_coronal, (:coronal, :anterior, :A, :posterior, :P)),
                     (is_axial, (:axial, :superior, :S, :inferior, :I))
                    )
        for v in vars
            @test f(v)
        end
    end
end
