using Test, Unitful, NamedDims, AxisIndices, MappedArrays

@testset "no units, no time" begin
    A = NIMArray(reshape(1:12, 3, 4), x=1:3, y =1:4)
    @test @inferred(timeaxis(A)) === nothing
    @test !has_time_axis(A)
    @test timedim(A) == 0
    @test nimages(A) == 1
    @test @inferred(pixelspacing(A)) === (1,1)
    @test @inferred(spacedirections(A)) === ((1,0),(0,1))
    @test @inferred(coords_spatial(A)) === (1,2)
    @test @inferred(spatialorder(A)) === (:x, :y)
    @test @inferred(size_spatial(A)) === (3,4)
    @test @inferred(indices_spatial(A)) === (Base.OneTo(3), Base.OneTo(4))
    @test_throws ErrorException assert_timedim_last(A)
    #@test map(istimeaxis, AxisArrays.axes(A)) == (false,false)

end

@testset "units, no time" begin
    mm = u"mm"     # in real use these should be global consts
    m = u"m"
    A = NIMArray(reshape(1:12, 3, 4), x = 1mm:1mm:3mm, y = 1m:2m:7m)
    @test @inferred(timeaxis(A)) === nothing
    @test !has_time_axis(A)
    @test timedim(A) == 0
    @test nimages(A) == 1
    @test @inferred(pixelspacing(A)) === (1mm,2m)
    @test spacedirections(A) === ((1mm,0m),(0mm,2m))   # TODO: make this inferrable
    @test @inferred(coords_spatial(A)) === (1,2)
    @test spatialorder(A) === (:x,:y)
    @test @inferred(size_spatial(A)) === (3,4)
    @test @inferred(indices_spatial(A)) === (Base.OneTo(3),Base.OneTo(4))
    @test_throws ErrorException assert_timedim_last(A)
    #@test map(istimeaxis, AxisArrays.axes(A)) == (false,false)
end

@testset "units, time" begin
    s = u"s" # again, global const
    A = NIMArray(reshape(1:12, 3, 4), x = 1:3, time = 1s:1s:4s)
    @test @inferred(timeaxis(A)) === 1s:1s:4s
    @test has_time_axis(A)
    @test timedim(A) == 2
    @test nimages(A) == 4
    @test @inferred(pixelspacing(A)) === (1,)
    @test @inferred(spacedirections(A)) === ((1,),)
    @test @inferred(coords_spatial(A)) === (1,)
    @test spatialorder(A) === (:x,)
    @test @inferred(size_spatial(A)) === (3,)
    @test @inferred(indices_spatial(A)) === (Base.OneTo(3),)
    @test isnothing(assert_timedim_last(A))
    #@test map(istimeaxis, AxisArrays.axes(A)) == (false,true)
end

@testset "units, time first" begin
    s = u"s" # global const
    A = NIMArray(reshape(1:12, 4, 3), time = 1s:1s:4s, x = 1:3)
    @test @inferred(timeaxis(A)) === 1s:1s:4s
    @test has_time_axis(A)
    @test timedim(A) == 1
    @test nimages(A) == 4
    @test @inferred(pixelspacing(A)) === (1,)
    @test @inferred(spacedirections(A)) === ((1,),)
    @test @inferred(coords_spatial(A)) === (2,)
    @test spatialorder(A) === (:x,)
    @test @inferred(size_spatial(A)) === (3,)
    @test @inferred(indices_spatial(A)) === (Base.OneTo(3),)
    @test_throws ErrorException assert_timedim_last(A)
    #@test map(istimeaxis, AxisArrays.axes(A)) == (true,false)
end

# TODO
@testset "grayscale" begin
    A = NIMArray(rand(Gray{N0f8}, 4, 5), :y, :x)
    #@test summary(A) == "2-dimensional AxisArray{Gray{N0f8},2,...} with axes:\n    :y, Base.OneTo(4)\n    :x, Base.OneTo(5)\nAnd data, a 4×5 Array{Gray{N0f8},2} with eltype Gray{Normed{UInt8,8}}"
    cv = channel_view(A)
    @test axes(cv) == (1:4, 1:5)
    @test spatialorder(cv) == (:y, :x)
    @test colordim(cv) == 0
end


@testset "color" begin
    A = NIMArray(rand(RGB{N0f8}, 4, 5), :y, :x)
    cv = channel_iew(A)
    @test axes(cv) == (1:3, 1:4, 1:5)
    @test spatialorder(cv) == (:y, :x)
    @test colordim(cv) == 1
    p = permuteddimsview(cv, (2,3,1))
    @test dimnames(p) == (:y, :x, :color)
    @test axes(p) == (1:4, 1:5, 1:3)
    @test colordim(p) == 3
    @test has_color_axis(p)
    @test indices_color(p) == 1:3
end

@testset "frequency" begin
    a = rand(2,2)
    nia = NIArray(a, x = 2:3, frequency = 3:4)
    @test has_frequency_axis(nia)
    @test frequencyaxis(nia) == 3:4
    @test indices_frequency(nia) == 1:2
    @test frequencydim(nia) == 2
end

@testset "channel" begin
    a = rand(2,2)
    nia = NIArray(a, x = 2:3, channel = 3:4)
    @test has_channel_axis(nia)
    @test channelaxis(nia) == 3:4
    @test indices_channel(nia) == 1:2
    @test channeldim(nia) == 2
end

@testset "observation" begin
    a = rand(2,2)
    nia = NIArray(a, x = 2:3, observation = 3:4)
    @test has_observation_axis(nia)
    @test observationaxis(nia) == 3:4
    @test indices_observation(nia) == 1:2
    @test observationdim(nia) == 2
end

@testset "nested" begin
    A = NIMArray(rand(RGB{N0f8}, 4, 5), y = range(1, step=2, length=4), x = 1:5)
    P = permuteddimsview(A, (2, 1))
    @test @inferred(pixelspacing(P)) == (1, 2)
    #M = mappedarray(identity, A)
    #@test @inferred(pixelspacing(M)) == (2, 1)
    s = u"s" # global const
    μm = u"μm" # global const
    A = NIMArray(rand(N0f16, 4, 5, 11),
                 y = range(1μm, step=2μm, length=4),
                 x = range(1μm, step = 1μm, length=5),
                 time = range(0.0s, step=0.1s, length=11))
    P = permuteddimsview(A, (3, 1, 2))
    M = mappedarray(identity, A)
    @test @inferred(pixelspacing(P)) == @inferred(pixelspacing(M)) == (2μm, 1μm)
    @test @inferred(timeaxis(P)) == @inferred(timeaxis(M)) == range(0.0s, step=0.1s, length=11)
    @test has_time_axis(P)
    @test coords_spatial(P) == (2, 3)
    @test coords_spatial(M) == (1, 2)
    @test spatialorder(P) == spatialorder(M) == (:y, :x)
    @test sampling_rate(P) == 1 / step(timeaxis(P))
    @test time_end(P) == last(timeaxis(P))
    @test onset(P) == first(timeaxis(P))
    @test @inferred(size_spatial(P)) == @inferred(size_spatial(M)) == (4, 5)
    @test_throws ErrorException assert_timedim_last(P)
    assert_timedim_last(M)

    A = NIMArray(rand(N0f16, 11, 5, 4),
                  time = range(0.0s, step=0.1s, length=11),
                  x = range(1μm, step = 1μm, length=5),
                  y = range(1μm, step=2μm, length=4))
    P = permuteddimsview(A, (3, 2, 1))
    M = mappedarray(identity, A)
    @test @inferred(pixelspacing(P)) == (2μm, 1μm)
    @test @inferred(pixelspacing(M)) == (1μm, 2μm)
    @test @inferred(timeaxis(P)) == @inferred(timeaxis(M)) == range(0.0s, step=0.1s, length=11)
    @test has_time_axis(P)
    @test coords_spatial(P) == (1, 2)
    @test coords_spatial(M) == (2, 3)
    @test spatialorder(P) == (:y, :x)
    @test spatialorder(M) == (:x, :y)
    @test @inferred(size_spatial(P)) == (4, 5)
    @test @inferred(size_spatial(M)) == (5, 4)
    @test assert_timedim_last(P) == nothing
    @test_throws ErrorException assert_timedim_last(M)
end


# Possibly-ambiguous functions
@testset "ambig" begin
    A = NIMArray(rand(RGB{N0f8},3,5), :x, :y)
    @test isa(convert(Array{RGB{N0f8},2}, A), Array{RGB{N0f8},2})
    @test isa(convert(Array{Gray{N0f8},2}, A), Array{Gray{N0f8},2})
end

@testset "internal" begin
    A = NIMArray(rand(RGB{N0f8},3,5), :x, :y)
    @test axes(A) isa Tuple{Vararg{<:AbstractAxis}}
end

@testset "ImageMetadata" begin
    a = rand(2,2)
    nia = NIArray(a, x = 2:3, y = 3:4)
    ima = IMArray(a, 2:3, 3:4)
    nima = NIMArray(a, x = 2:3, y = 3:4)
    ma = MetaArray(a)

    @test isempty(properties(ma))
    @test isempty(properties(ima))
    @test isempty(properties(nima))

    ma.foo = true
    ima.foo = true
    nima.foo = true

    @test ma.foo
    @test ima.foo
    @test nima.foo

    @test first(properties(ma)) == Pair(:foo, true)
    @test first(properties(ima)) == Pair(:foo, true)
    @test first(properties(nima)) == Pair(:foo, true)
end


