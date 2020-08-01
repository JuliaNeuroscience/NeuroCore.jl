# backward-compatibility to ColorTypes < v0.9 or Colors < v0.11

struct ArrayLF{T,N} <: AbstractArray{T,N}
    A::Array{T,N}
end
Base.IndexStyle(::Type{A}) where {A<:ArrayLF} = IndexLinear()
Base.size(A::ArrayLF) = size(A.A)
Base.getindex(A::ArrayLF, i::Int) = A.A[i]
Base.setindex!(A::ArrayLF, val, i::Int) = A.A[i] = val

struct ArrayLS{T,N} <: AbstractArray{T,N}
    A::Array{T,N}
end
Base.IndexStyle(::Type{A}) where {A<:ArrayLS} = IndexCartesian()
Base.size(A::ArrayLS) = size(A.A)
Base.getindex(A::ArrayLS{T,N}, i::Vararg{Int,N}) where {T,N} = A.A[i...]
Base.setindex!(A::ArrayLS{T,N}, val, i::Vararg{Int,N}) where {T,N} = A.A[i...] = val

@testset "channel_view" begin

@testset "grayscale" begin
    a = rand(2,3)
    @test channel_view(a) === a

    a0 = [Gray(N0f8(0.2)), Gray(N0f8(0.4))]
    for (a, LI) in ((copy(a0), IndexLinear()),
                    (ArrayLF(copy(a0)), IndexLinear()),
                    (ArrayLS(copy(a0)), IndexCartesian()))
        v = @inferred(channel_view(a))
        @test @inferred(IndexStyle(v)) == LI
        @test ndims(v) == 1
        @test size(v) == (2,)
        @test eltype(v) == N0f8
        @test @inferred(color_view(Gray, v)) === a
        @test parent(parent(v)) === a
        @test v[1] == N0f8(0.2)
        @test v[2] == N0f8(0.4)
        @test_throws BoundsError v[0]
        @test_throws BoundsError v[3]
        v[1] = 0.8
        @test a[1] === Gray(N0f8(0.8))
        @test_throws BoundsError (v[0] = 0.6)
        @test_throws BoundsError (v[3] = 0.6)
        c = similar(v)
        @test eltype(c) == N0f8 && ndims(c) == 1
        @test length(c) == 2
        c = similar(v, 3)
        @test eltype(c) == N0f8 && ndims(c) == 1
        @test length(c) == 3
        c = similar(v, Float32)
        @test eltype(c) == Float32 && ndims(c) == 1
        @test length(c) == 2
        c = similar(v, Float16, (5,5))
        @test eltype(c) == Float16 && ndims(c) == 2
        @test size(c) == (5,5)
    end
end

@testset "RGB, HSV, etc" begin
    for T in (RGB, BGR, XRGB, RGBX, HSV, Lab, XYZ)
        a0 = [T(0.1,0.2,0.3), T(0.4, 0.5, 0.6)]
        for a in (copy(a0),
                  ArrayLS(copy(a0)))
            v = @inferred(channel_view(a))
            @test ndims(v) == 2
            @test size(v) == (3,2)
            @test eltype(v) == Float64
            if T in (RGB, HSV, Lab, XYZ)
                @test @inferred(color_view(T, v)) == a && color_view(T, v) isa typeof(a)
            else
                @test @inferred(color_view(T, v)) == a
            end
            @test v[1] == v[1,1] == 0.1
            @test v[2] == v[2,1] == 0.2
            @test v[3] == v[3,1] == 0.3
            @test v[4] == v[1,2] == 0.4
            @test v[5] == v[2,2] == 0.5
            @test v[6] == v[3,2] == 0.6
            @test_throws BoundsError v[0,1]
            @test_throws BoundsError v[4,1]
            @test_throws BoundsError v[2,0]
            @test_throws BoundsError v[2,3]
            v[2] = 0.8
            @test a[1] == T(0.1,0.8,0.3)
            v[2,1] = 0.7
            @test a[1] == T(0.1,0.7,0.3)
            @test_throws BoundsError (v[0,1] = 0.7)
            @test_throws BoundsError (v[4,1] = 0.7)
            @test_throws BoundsError (v[2,0] = 0.7)
            @test_throws BoundsError (v[2,3] = 0.7)
            c = similar(v)
            @test size(c) == (3,2) && eltype(c) == Float64
            c = similar(v, (3,4))
            @test size(c) == (3,4) && eltype(c) == Float64
            c = similar(v, Float32)
            @test size(c) == (3,2) && eltype(c) == Float32
            c = similar(v, Float16, (3,5,5))
            @test size(c) == (3,5,5) && eltype(c) == Float16
        end
    end
    #= FIXME
    a = reshape([RGB(1,0,0)])  # 0-dimensional
    v = @inferred(channel_view(a))
    @test axes(v) === (Base.OneTo(3),)
    v = @inferred(channel_view(a))
    @test axes(v) === (Base.OneTo(3),)
    =#
end

@testset "Gray+Alpha" begin
    for T in (AGray, GrayA)
        a = [T(0.1f0,0.2f0), T(0.3f0,0.4f0), T(0.5f0,0.6f0)]
        v = @inferred(channel_view(a))
        @test @inferred(color_view(T, v)) == a
        @test ndims(v) == 2
        @test size(v) == (2,3)
        @test eltype(v) == Float32
        @test v[1] == v[1,1] == 0.1f0
        @test v[2] == v[2,1] == 0.2f0
        @test v[3] == v[1,2] == 0.3f0
        @test v[4] == v[2,2] == 0.4f0
        @test v[5] == v[1,3] == 0.5f0
        @test v[6] == v[2,3] == 0.6f0
        @test_throws BoundsError v[0,1]
        @test_throws BoundsError v[3,1]
        @test_throws BoundsError v[2,0]
        @test_throws BoundsError v[2,4]
        v[2] = 0.8
        @test a[1] == T(0.1f0,0.8f0)
        v[2,1] = 0.7
        @test a[1] == T(0.1f0,0.7f0)
        @test_throws BoundsError (v[0,1] = 0.7)
        @test_throws BoundsError (v[3,1] = 0.7)
        @test_throws BoundsError (v[2,0] = 0.7)
        @test_throws BoundsError (v[2,4] = 0.7)
        c = similar(v)
        @test eltype(c) == Float32
        @test size(c) == (2,3)
        c = similar(v, (2,4))
        @test eltype(c) == Float32
        @test size(c) == (2,4)
        c = similar(v, Float64)
        @test eltype(c) == Float64
        @test size(c) == (2,3)
        c = similar(v, Float16, (2,5,5))
        @test eltype(c) == Float16
        @test size(c) == (2,5,5)
    end
end

@testset "Alpha+RGB, HSV, etc" begin
    for T in (ARGB,
              ABGR,
              AHSV,
              ALab,
              AXYZ,
              RGBA,
              BGRA,
              LabA,
              XYZA)
        a = [T(0.1,0.2,0.3,0.4), T(0.5,0.6,0.7,0.8)]
        v = @inferred(channel_view(a))
        @test ndims(v) == 2
        @test size(v) == (4,2)
        @test eltype(v) == Float64
        @test v[1] == v[1,1] == 0.1
        @test v[2] == v[2,1] == 0.2
        @test v[3] == v[3,1] == 0.3
        @test v[4] == v[4,1] == 0.4
        @test v[5] == v[1,2] == 0.5
        @test v[6] == v[2,2] == 0.6
        @test v[7] == v[3,2] == 0.7
        @test v[8] == v[4,2] == 0.8
        @test_throws BoundsError v[0,1]
        @test_throws BoundsError v[5,1]
        @test_throws BoundsError v[2,0]
        @test_throws BoundsError v[2,3]
        v[2] = 0.9
        @test a[1] == T(0.1,0.9,0.3,0.4)
        v[2,1] = 0.7
        @test a[1] == T(0.1,0.7,0.3,0.4)
        @test_throws BoundsError (v[0,1] = 0.7)
        @test_throws BoundsError (v[5,1] = 0.7)
        @test_throws BoundsError (v[2,0] = 0.7)
        @test_throws BoundsError (v[2,3] = 0.7)
        c = similar(v)
        @test eltype(c) == Float64
        @test size(c) == (4,2)
        c = similar(v, (4,4))
        @test eltype(c) == Float64
        @test size(c) == (4,4)
        c = similar(v, Float32)
        @test eltype(c) == Float32
        @test size(c) == (4,2)
        c = similar(v, Float16, (4,5,5))
        @test eltype(c) == Float16
        @test size(c) == (4,5,5)
    end

    #= FIXME using AxisIndices.OffsetArray
    @testset "Non-1 indices" begin
        a = OffsetArray(rand(RGB{N0f8}, 3, 5), -1:1, -2:2)
        v = @inferred(channel_view(a))
        @test @inferred(axes(v)) == (IdentityUnitRange(1:3), IdentityUnitRange(-1:1), IdentityUnitRange(-2:2))
        @test @inferred(v[1,0,0]) === a[0,0].r
        a = OffsetArray(rand(Gray{Float32}, 3, 5), -1:1, -2:2)
        v = @inferred(channel_view(a))
        @test @inferred(axes(v)) == (IdentityUnitRange(-1:1), IdentityUnitRange(-2:2))
        @test @inferred(v[0,0]) === gray(a[0,0])
        @test @inferred(v[5]) === gray(a[5])
        v[5] = -1
        @test v[5] === -1.0f0
    end
    =#
end

end

@testset "color_view" begin

@testset "grayscale" begin
    a0 = [N0f8(0.2), N0f8(0.4)]
    for (a, LI) in ((copy(a0), IndexLinear()),
                    (ArrayLF(copy(a0)), IndexLinear()),
                    (ArrayLS(copy(a0)), IndexCartesian()))
        @test_throws MethodError color_view(a)
        v = @inferred(color_view(Gray, a))
        @test @inferred(IndexStyle(v)) == LI
        @test ndims(v) == 1
        @test size(v) == (2,)
        @test eltype(v) == Gray{N0f8}
        @test @inferred(channel_view(v)) === a
        @test parent(parent(v)) === a
        @test v[1] == Gray(N0f8(0.2))
        @test v[2] == Gray(N0f8(0.4))
        @test_throws BoundsError v[0]
        @test_throws BoundsError v[3]
        v[1] = 0.8
        @test a[1] === N0f8(0.8)
        @test_throws BoundsError (v[0] = 0.6)
        @test_throws BoundsError (v[3] = 0.6)
        c = similar(v)
        @test eltype(c) == Gray{N0f8} && ndims(c) == 1
        @test length(c) == 2
        c = similar(v, 3)
        @test eltype(c) == Gray{N0f8} && ndims(c) == 1
        @test length(c) == 3
        c = similar(v, Gray{Float32})
        @test eltype(c) == Gray{Float32}
        @test length(c) == 2
        c = similar(v, Gray{Float16}, (5,5))
        @test eltype(c) == Gray{Float16}
        @test size(c) == (5,5)
        c = similar(v, Float32)
        @test isa(c, Array{Float32, 1})
    end
    # two dimensional images and linear indexing
    a0 = N0f8[0.2 0.4; 0.6 0.8]
    for (a, LI) in ((copy(a0), IndexLinear()),
                    (ArrayLF(copy(a0)), IndexLinear()),
                    (ArrayLS(copy(a0)), IndexCartesian()))
        @test_throws MethodError color_view(a)
        v = @inferred(color_view(Gray, a))
        @test @inferred(IndexStyle(v)) == LI
        @test ndims(v) == 2
        @test size(v) == (2,2)
        @test eltype(v) == Gray{N0f8}
        @test @inferred(channel_view(v)) === a
        @test parent(parent(v)) === a
        @test v[1] == Gray(N0f8(0.2))
        @test v[2] == Gray(N0f8(0.6))
        @test_throws BoundsError v[0]
        @test_throws BoundsError v[5]
        v[1] = 0.9
        @test a[1] === N0f8(0.9)
        @test_throws BoundsError (v[0] = 0.6)
        @test_throws BoundsError (v[5] = 0.6)
    end
end

@testset "RGB, HSV, etc" begin
    for T in (RGB, BGR, XRGB, RGBX, HSV, Lab, XYZ)
        a0 = [0.1 0.2 0.3; 0.4 0.5 0.6]'
        for a in (copy(a0),
                  ArrayLS(copy(a0)))
            v = @inferred(color_view(T,a))
            @test @inferred(channel_view(v)) === a
            @test ndims(v) == 1
            @test size(v) == (2,)
            @test eltype(v) == T{Float64}
            @test v[1] == T(0.1,0.2,0.3)
            @test v[2] == T(0.4,0.5,0.6)
            @test_throws BoundsError v[0]
            @test_throws BoundsError v[3]
            v[2] = T(0.8, 0.7, 0.6)
            @test a == [0.1 0.2 0.3; 0.8 0.7 0.6]'
            @test_throws BoundsError (v[0] = T(0.8, 0.7, 0.6))
            @test_throws BoundsError (v[3] = T(0.8, 0.7, 0.6))
            c = similar(v)
            @test size(c) == (2,)
            c = similar(v, 4)
            @test size(c) == (4,)
            c = similar(v, T{Float32})
            @test size(c) == (2,)
            c = similar(v, T)
            @test size(c) == (2,)
            c = similar(v, T{Float16}, (5,5))
            @test size(c) == (5,5)
            c = similar(v, RGB24)
            @test eltype(c) == RGB24
            @test size(c) == size(v)
        end
    end
end

@testset "Gray+Alpha" begin
    for T in (AGray, GrayA)
        a = [0.1f0 0.2f0; 0.3f0 0.4f0; 0.5f0 0.6f0]'
        v = @inferred(color_view(T, a))
        @test ndims(v) == 1
        @test size(v) == (3,)
        @test eltype(v) == T{Float32}
        @test @inferred(channel_view(v)) === a
        @test v[1] == T(0.1f0, 0.2f0)
        @test v[2] == T(0.3f0, 0.4f0)
        @test v[3] == T(0.5f0, 0.6f0)
        @test_throws BoundsError v[0]
        @test_throws BoundsError v[4]
        v[2] = T(0.8, 0.7)
        @test a[1,2] === 0.8f0
        @test a[2,2] === 0.7f0
        @test_throws BoundsError (v[0] = T(0.8,0.7))
        @test_throws BoundsError (v[4] = T(0.8,0.7))
        c = similar(v)
        @test eltype(c) == T{Float32}
        @test size(c) == (3,)
        c = similar(v, (4,))
        @test eltype(c) == T{Float32}
        @test size(c) == (4,)
        c = similar(v, T{Float64})
        @test eltype(c) == T{Float64}
        @test size(c) == (3,)
        c = similar(v, T{Float16}, (5,5))
        @test eltype(c) == T{Float16}
        @test size(c) == (5,5)
    end
end

@testset "Alpha+RGB, HSV, etc" begin
    a = rand(ARGB{N0f8}, 5, 5)
    vc = @inferred(channel_view(a))
    @test eltype(@inferred(color_view(ARGB, vc))) == ARGB{N0f8}
    cvc = @inferred(color_view(RGBA, vc))
    @test all(cvc .== a)

    for T in (ARGB,
              ABGR,
              AHSV,
              ALab,
              AXYZ,
              RGBA,
              BGRA,
              HSVA,
              LabA,
              XYZA)
        a = [0.1 0.2 0.3 0.4; 0.5 0.6 0.7 0.8]'
        v = @inferred(color_view(T, a))
        @test eltype(v) == T{Float64}
        @test @inferred(channel_view(v)) === a
        @test ndims(v) == 1
        @test size(v) == (2,)
        @test eltype(v) == T{Float64}
        @test v[1] == T(0.1,0.2,0.3,0.4)
        @test v[2] == T(0.5,0.6,0.7,0.8)
        @test_throws BoundsError v[0]
        @test_throws BoundsError v[3]
        v[2] = T(0.9,0.8,0.7,0.6)
        @test a[1,2] == 0.9
        @test a[2,2] == 0.8
        @test a[3,2] == 0.7
        @test a[4,2] == 0.6
        @test_throws BoundsError (v[0] = T(0.9,0.8,0.7,0.6))
        @test_throws BoundsError (v[3] = T(0.9,0.8,0.7,0.6))
        c = similar(v)
        @test eltype(c) == T{Float64}
        @test size(c) == (2,)
        c = similar(v, 4)
        @test eltype(c) == T{Float64}
        @test size(c) == (4,)
        c = similar(v, T{Float32})
        @test eltype(c) == T{Float32}
        @test size(c) == (2,)
        c = similar(v, T{Float16}, (5,5))
        @test eltype(c) == T{Float16}
        @test size(c) == (5,5)
    end

    #= FIXME using AxisIndices.OffsetArray
    @testset "Non-1 indices" begin
        a = OffsetArray(rand(3, 3, 5), 1:3, -1:1, -2:2)
        v = @inferred(color_view(RGB, a))
        @test @inferred(axes(v)) == (IdentityUnitRange(-1:1), IdentityUnitRange(-2:2))
        @test @inferred(v[0,0]) === RGB(a[1,0,0], a[2,0,0], a[3,0,0])
        a = OffsetArray(rand(3, 3, 5), 0:2, -1:1, -2:2)
        @test_throws DimensionMismatch color_view(RGB, a)
    end
    =#
end

@testset "grayscale" begin
    A = NamedAxisArray{(:y, :x)}(rand(Gray{N0f8}, 4, 5));
    # FIXME
    #@test summary(A) == "2-dimensional AxisArray{Gray{N0f8},2,...} with axes:\n    :y, Base.OneTo(4)\n    :x, Base.OneTo(5)\nAnd data, a 4×5 Array{Gray{N0f8},2} with eltype Gray{Normed{UInt8,8}}"
    cv = channel_view(A);
    @test named_axes(cv) == (y = 1:4, x = 1:5)
    @test spatial_order(cv) == (:y, :x)
    @test_throws ArgumentError channeldim(cv)
end

@testset "color" begin
    A = NamedAxisArray{(:y, :x)}(rand(RGB{N0f8}, 4, 5));
    cv = channel_view(A);
    @test @inferred(named_axes(cv)) == (color = 1:3, y = 1:4, x = 1:5)
    @test @inferred(spatial_order(cv)) == (:y, :x)
    @test @inferred(channeldim(cv)) == 1
    p = permuteddimsview(cv, (2,3,1))
    @test @inferred(named_axes(p)) == (y = 1:4, x = 1:5, color = 1:3)
    @test channeldim(p) == 3
end

@testset "nested" begin
    A = NamedAxisArray(rand(RGB{N0f8}, 4, 5), y = range(1, step=2, length=4), x=1:5);
    P = permuteddimsview(A, (2, 1));
    @test @inferred(pixel_spacing(P)) == (1, 2)
    M = mappedarray(identity, A)
    @test @inferred(pixel_spacing(M)) == (2, 1)
    s = u"s" # global const
    μm = u"μm" # global const
    tax = range(0.0s, step=0.1s, length=11)
    A = NamedAxisArray(rand(N0f16, 4, 5, 11),
                  y = range(1μm, step=2μm, length=4),
                  x = range(1μm, step=1μm, length=5),
                  time = tax)
    P = permuteddimsview(A, (3, 1, 2));
    M = mappedarray(identity, A);
    @test @inferred(pixel_spacing(P)) == @inferred(pixel_spacing(M)) == (2μm, 1μm)
    @test @inferred(time_keys(P)) == @inferred(time_keys(M)) == tax
    @test has_timedim(P)
    @test spatialdims(P) == (2, 3)
    @test spatialdims(M) == (1, 2)
    @test spatial_order(P) == spatial_order(M) == (:y, :x)
    @test @inferred(spatial_size(P)) == @inferred(spatial_size(M)) == (4, 5)
    @test_throws ErrorException assert_timedim_last(P)
    assert_timedim_last(M)
    A = NamedAxisArray(rand(N0f16, 11, 5, 4),
                       (time = tax,
                        x = range(1μm, step=1μm, length=5),
                        y = range(1μm, step=2μm, length=4)))
    P = permuteddimsview(A, (3, 2, 1))
    M = mappedarray(identity, A)
    @test @inferred(spatial_keys(P)) == ((1:2:7)μm, (1:5)μm)
    @test @inferred(pixel_spacing(P)) == (2μm, 1μm)
    @test @inferred(pixel_spacing(M)) == (1μm, 2μm)
    @test @inferred(time_keys(P)) == @inferred(time_keys(M)) == tax
    @test has_timedim(P)
    @test spatialdims(P) == (1, 2)
    @test spatialdims(M) == (2, 3)
    @test spatial_order(P) == (:y, :x)
    @test spatial_order(M) == (:x, :y)
    @test @inferred(spatial_size(P)) == (4, 5)
    @test @inferred(spatial_size(M)) == (5, 4)
    assert_timedim_last(P)
    @test_throws ErrorException assert_timedim_last(M)
end


end

nothing