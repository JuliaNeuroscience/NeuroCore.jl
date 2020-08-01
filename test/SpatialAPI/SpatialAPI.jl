@testset "spatial" begin

@testset "no units, no time" begin
    A = NamedAxisArray(reshape(1:12, 3, 4), x = 1:3, y = 1:4);
    @test_throws ArgumentError time_axis(A)
    @test !has_timedim(A)
    @test_throws ArgumentError timedim(A)
    @test ntime(A) == 1
    @test @inferred(pixel_spacing(A)) === (1,1)
    @test @inferred(spatial_directions(A)) === ((1,0),(0,1))
    @test @inferred(spatialdims(A)) === (1, 2)
    @test @inferred(spatial_order(A)) === (:x, :y)
    @test @inferred(spatial_size(A)) === (3,4)
    @test @inferred(spatial_indices(A)) === (Base.OneTo(3), Base.OneTo(4))
    assert_timedim_last(A)
end

@testset "units, no time" begin
    mm = u"mm"     # in real use these should be global consts
    m = u"m"
    A = NamedAxisArray(reshape(1:12, 3, 4), x = 1mm:1mm:3mm, y = 1m:2m:7m)
    @test_throws ArgumentError time_axis(A)
    @test !has_timedim(A)
    @test_throws ArgumentError timedim(A)
    @test ntime(A) == 1
    @test @inferred(pixel_spacing(A)) === (1mm,2m)
    @test @inferred(spatial_directions(A)) === ((1mm,0m),(0mm,2m))
    @test @inferred(spatialdims(A)) === (1,2)
    @test @inferred(spatial_order(A)) === (:x,:y)
    @test @inferred(spatial_size(A)) === (3,4)
    @test @inferred(spatial_indices(A)) === (Base.OneTo(3),Base.OneTo(4))
    assert_timedim_last(A)
end

@testset "units, time" begin
    s = u"s" # again, global const
    A = NamedAxisArray(reshape(1:12, 3, 4), x = 1:3, time = 1s:1s:4s)
    @test @inferred(time_keys(A)) == 1s:1s:4s
    @test has_timedim(A)
    @test timedim(A) == 2
    @test ntime(A) == 4
    @test @inferred(pixel_spacing(A)) === (1,)
    @test @inferred(spatial_directions(A)) === ((1,),)
    @test @inferred(coords_spatial(A)) === (1,)
    @test @inferred(spatialorder(A)) === (:x,)
    @test @inferred(size_spatial(A)) === (3,)
    @test @inferred(spatial_indices(A)) === (Base.OneTo(3),)
    assert_timedim_last(A)
end

@testset "units, time first" begin
    s = u"s" # global const
    A = NamedAxisArray(reshape(1:12, 4, 3), time = 1s:1s:4s, x = 1:3)
    @test @inferred(time_keys(A)) === 1s:1s:4s
    @test has_timedim(A)
    @test timedim(A) == 1
    @test ntime(A) == 4
    @test @inferred(pixel_spacing(A)) === (1,)
    @test @inferred(spatial_directions(A)) === ((1,),)
    @test @inferred(coords_spatial(A)) === (2,)
    @test @inferred(spatial_order(A)) === (:x,)
    @test @inferred(spatial_size(A)) === (3,)
    @test @inferred(spatial_indices(A)) === (Base.OneTo(3),)
    @test_throws ErrorException assert_timedim_last(A)
end


end