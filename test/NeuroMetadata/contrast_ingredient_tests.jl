
@testset "Contrast Ingredients" begin
    @test ContrastIngredient(0) == ContrastIngredient("IODINE")
    @test ContrastIngredient(1) == ContrastIngredient("GADOLINIUM")
    @test ContrastIngredient(2) == ContrastIngredient("CARBON")
    @test ContrastIngredient(3) == ContrastIngredient("DIOXIDE")
    @test ContrastIngredient(4) == ContrastIngredient("BARIUM")
    @test ContrastIngredient(5) == ContrastIngredient("XENON")
    @test ContrastIngredient(6) == ContrastIngredient("UnkownContrast")
    @test Symbol(String(ContrastIngredient(6))) == Symbol(ContrastIngredient("PLUTIONIUM"))
end

