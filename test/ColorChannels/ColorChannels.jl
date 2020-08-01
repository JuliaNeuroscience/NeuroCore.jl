
using Colors
using FixedPointNumbers
using Test
using Random
using NeuroCore.ColorChannels
using AxisIndices
using MappedArrays
using TimeAxes

using AxisIndices.PaddedViews: filltype, paddedviews, PaddedView

using NeuroCore.ColorChannels: GenericImage, GenericGrayImage
using NeuroCore.ColorChannels: NumberLike, Pixel



include("channels.jl")
include("views.jl")
include("convert_reinterpret.jl")
include("traits.jl")

using FFTW

@testset "functions" begin
    ag = rand(Gray{Float32}, 4, 5)
    ac = rand(RGB{Float32}, 4, 5)
    for (f, args) in ((fft, (ag,)), (fft, (ag, 1:2)), (plan_fft, (ag,)),
                      (rfft, (ag,)), (rfft, (ag, 1:2)), (plan_rfft, (ag,)),
                      (fft, (ac,)), (fft, (ac, 1:2)), (plan_fft, (ac,)),
                      (rfft, (ac,)), (rfft, (ac, 1:2)), (plan_rfft, (ac,)))
        ret = @test_throws ErrorException f(args...)
        @test occursin("channel_view", ret.value.msg)
        @test occursin(eltype(args[1])<:Gray ? "1:2" : "2:3", ret.value.msg)
    end
    for (a, dims) in ((ag, 1:2), (ac, 2:3))
        @test ifft(fft(channel_view(a), dims), dims) ≈ channel_view(a)
        ret = @test_throws ErrorException rfft(a)
        @test occursin("channel_view", ret.value.msg)
        @test occursin("$dims", ret.value.msg)
        @test irfft(rfft(channel_view(a), dims), 4, dims) ≈ channel_view(a)
    end


    a = [RGB(1,0,0), RGB(0,1,0), RGB(0,0,1)]
    @test a' == [RGB(1,0,0) RGB(0,1,0) RGB(0,0,1)]

    a = [RGB(1,0,0) RGB(0,1,0); RGB(0,0,1) RGB(0, 0, 0)]
    @test a' == [RGB(1,0,0) RGB(0,0,1); RGB(0,1,0) RGB(0, 0, 0)]
end
