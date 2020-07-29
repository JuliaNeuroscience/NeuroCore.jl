import NeuroCore: EncodingDirection

@testset "Encoding directions" begin
    @test EncodingDirection(1) == EncodingDirection("ipos") == EncodingDirection("i")
    @test EncodingDirection(-1) == EncodingDirection("ineg") == EncodingDirection("i-")
    @test EncodingDirection(2) == EncodingDirection("jpos") == EncodingDirection("j")
    @test EncodingDirection(-2) == EncodingDirection("jneg") == EncodingDirection("j-")
    @test EncodingDirection(3) == EncodingDirection("kpos") == EncodingDirection("k")
    @test EncodingDirection(-3) == EncodingDirection("kneg") == EncodingDirection("k-")
    @test String(EncodingDirection(-3)) == "kneg"

    @test_throws ErrorException EncodingDirection(:xyz)
end

