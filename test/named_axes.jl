using MappedArrays
using Test

#ambs = detect_ambiguities(ImageCore,AxisArrays,Base,Core)
#ambs = setdiff(detect_ambiguities(ImageAxes,ImageCore,AxisArrays,Base,Core), ambs)
#=
if !isempty(ambs)
    println("Ambiguities:")
    for a in ambs
        println(a)
    end
end
@test isempty(ambs)
=#

#@traitfn has_time_axis(::AA) where {AA<:AxisArray;  HasTimeAxis{AA}} = true
#@traitfn has_time_axis(::AA) where {AA<:AxisArray; !HasTimeAxis{AA}} = false

@testset "no units, no time" begin
    A = AxisArray(reshape(1:12, 3, 4), x = (1:3), y = (1:4))
    @test @inferred(timeaxis(A)) === nothing
    @test !has_time_axis(A)
    @test timedim(A) == 0
    @test @inferred(pixelspacing(A)) === (1,1)
    @test @inferred(spacedirections(A)) === ((1,0),(0,1))
    @test @inferred(coords_spatial(A)) === (1,2)
    @test spatialorder(A) === (:x, :y)  # TODO: make this inferrable
    @test @inferred(size_spatial(A)) === (3,4)
    @test @inferred(indices_spatial(A)) === (Base.OneTo(3), Base.OneTo(4))
    assert_timedim_last(A)
    @test map(istimeaxis, AxisArrays.axes(A)) == (false,false)

    @test @inferred(timeaxis(rand(3,5))) == nothing


    # deprecate
    @test nimages(A) == 1
end

@testset "units, no time" begin
    mm = u"mm"     # in real use these should be global consts
    m = u"m"
    A = AxisArray(reshape(1:12, 3, 4), x = (1mm:1mm:3mm), y = (1m:2m:7m))
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
    assert_timedim_last(A)
    @test map(istimeaxis, AxisArrays.axes(A)) == (false,false)
end

@testset "units, time" begin
    s = u"s" # again, global const
    axt = Axis(1s:1s:4s)
    A = AxisArray(reshape(1:12, 3, 4), Axis(1:3), axt)
    @test @inferred(timeaxis(A)) === axt
    @test has_time_axis(A)
    @test timedim(A) == 2
    @test nimages(A) == 4
    @test @inferred(pixelspacing(A)) === (1,)
    @test @inferred(spacedirections(A)) === ((1,),)
    @test @inferred(coords_spatial(A)) === (1,)
    @test spatialorder(A) === (:x,)
    @test @inferred(size_spatial(A)) === (3,)
    @test @inferred(indices_spatial(A)) === (Base.OneTo(3),)
    assert_timedim_last(A)
    @test map(istimeaxis, AxisArrays.axes(A)) == (false,true)
end

@testset "units, time first" begin
    s = u"s" # global const
    axt = Axis{:time}(1s:1s:4s)
    A = AxisArray(reshape(1:12, 4, 3), axt, Axis{:x}(1:3))
    @test @inferred(timeaxis(A)) === axt
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
    @test map(istimeaxis, AxisArrays.axes(A)) == (true,false)
end



# Possibly-ambiguous functions
@testset "ambig" begin
    A = AxisArray(rand(RGB{N0f8},3,5), :x, :y)
    @test isa(convert(Array{RGB{N0f8},2}, A), Array{RGB{N0f8},2})
    @test isa(convert(Array{Gray{N0f8},2}, A), Array{Gray{N0f8},2})
end

@testset "internal" begin
    A = AxisArray(rand(RGB{N0f8},3,5), :x, :y)
    @test ImageAxes.axtype(A) == Tuple{Axis{:x,Base.OneTo{Int}}, Axis{:y,Base.OneTo{Int}}}
end

# For testing streaming with a non-AxisArray parent
module TestStreaming
using AxisArrays, ImageAxes

struct AVIStream
    dims::NTuple{3,Int}
end
Base.ndims(::AVIStream) = 3
Base.size(A::AVIStream) = A.dims
AxisArrays.axisnames(::Type{AS}) where {AS<:AVIStream} = (:y, :x, :time)
AxisArrays.axes(A::AVIStream) = (Axis{:y}(Base.OneTo(A.dims[1])),
                                 Axis{:x}(Base.OneTo(A.dims[2])),
                                 Axis{:time}(Base.OneTo(A.dims[3])))
ImageAxes.StreamIndexStyle(::Type{AVIStream}, ::Type{typeof(read!)}) =
    IndexIncremental()

end

@testset "streaming" begin
    P = AxisArray([0 0 0 0;
                   1 2 3 4;
                   0 0 0 0], :x, :time)
    f!(dest, a) = (dest[1] = dest[3] = -0.2*a[2]; dest[2] = 0.6*a[2]; dest)
    # Next inference was special-cased for v0.6
    S = @inferred(StreamingContainer{Float64}(f!, P, Axis{:time}()))
    @test @inferred(axes(S)) === (Base.OneTo(3), Base.OneTo(4))
    @test @inferred(size(S)) == (3,4)
    @test @inferred(axes(S, 2)) === Base.OneTo(4)
    @test @inferred(size(S, 1)) === 3
    @test @inferred(length(S)) == 12
    @test @inferred(axisnames(S)) == (:x, :time)
    @test @inferred(axisvalues(S)) === (Base.OneTo(3), Base.OneTo(4))
    @test axisdim(S, Axis{:x}) == axisdim(S, Axis{:x}(1:2)) == axisdim(S, Axis{:x,UnitRange{Int}}) == 1
    @test axisdim(S, Axis{:time}) == 2
    @test_throws ErrorException axisdim(S, Axis{:y})
    @test axisdim(S, Axis{2}) == 2
    @test_throws ErrorException axisdim(S, Axis{3})
    @test @inferred(timeaxis(S)) === Axis{:time}(Base.OneTo(4))
    @test nimages(S) == 4
    @test @inferred(coords_spatial(S)) == (1,)
    @test @inferred(indices_spatial(S)) == (Base.OneTo(3),)
    @test @inferred(size_spatial(S)) == (3,)
    @test @inferred(spatialorder(S)) == (:x,)
    assert_timedim_last(S)
    for i = 1:4
        @test @inferred(S[:,i]) == [-0.2,0.6,-0.2]*i
        @test @inferred(S[2,i]) === 0.6*i
        @test @inferred(S[Axis{:time}(i)]) == [-0.2,0.6,-0.2]*i
        @test @inferred(S[Axis{:time}(i),Axis{:x}(2)]) === 0.6*i
        @test @inferred(S[Axis{:x}(2),Axis{:time}(i)]) === 0.6*i
    end
    buf = zeros(3)
    @test @inferred(getindex!(buf, S, :, 2)) == [-0.2,0.6,-0.2]*2
    @test StreamIndexStyle(S) === IndexAny()
    @test StreamIndexStyle(zeros(2,2)) === IndexAny()
    # Non-AbstractArray parent
    @test_throws DimensionMismatch StreamingContainer{UInt8}(read!, TestStreaming.AVIStream((1080,1920,10000)), Axis{:foo}())
    V = StreamingContainer{UInt8}(read!, TestStreaming.AVIStream((1080,1920,10000)), Axis{:time}())
    @test size(V) == (1080,1920,10000)
    @test axisnames(V) == (:y, :x, :time)
    @test StreamIndexStyle(V) === IndexIncremental()
    # internal
    @test ImageAxes.streamingaxisnames(S) == (:time,)
    @test ImageAxes.filter_streamed((1,2), S) == (2,)
end

nothing
