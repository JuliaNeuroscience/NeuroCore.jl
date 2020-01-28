@testset "axes tests" begin
    a = NeuroArray(rand(2,2,2), (sagittal = 1:2, axial = 1:2, coronal=1:2))
    @test dimnames(a) == (:sagittal, :axial, :coronal)
    @test dim(a, :sagittal) == 1 == sagittaldim(a)
    @test axialdim(a) == 2
    @test coronaldim(a) == 3
    @test indices_coronal(a) == 1:2
    @test indices_sagittal(a) == 1:2
    @test indices_axial(a) == 1:2
end
