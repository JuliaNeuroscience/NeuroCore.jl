# adapted from https://nifti.nimh.nih.gov/nifti-1/data
@testset "Orientations" begin
    @testset "Rotation matrices" begin
        R = AffineMap(RotMatrix{3,Float64}(reshape(1:9,3,3)), LinearMap((1.0, 1.0, 1.0)))
        @test NeuroCore.rotation2spatialorder(R.linear) == (:inferior, :posterior, :left)

        R = AffineMap(
            RotMatrix{3}([
                -2.0                    6.714715653593746e-19  9.081024511081715e-18
                6.714715653593746e-19  1.9737114906311035    -0.35552823543548584
                8.25548088896093e-18   0.3232076168060303     2.171081781387329
            ]),
            LinearMap((117.8551025390625, -35.72294235229492, -7.248798370361328))
        )

        @test NeuroCore.rotation2spatialorder(R.linear) == (:right, :posterior, :inferior)

        # TODO This is off and needs testing
        #Q = NeuroCore.mat2quat(R, (2.0, 2.0, 2.1999990940093994))
        #R2 = NeuroCore.quat2mat(Q, (2.0, 2.0, 2.1999990940093994))

        R = RotMatrix{3}([
            -1.0  0.0  0.0
            0.0  1.0  0.0
            0.0  0.0  1.0])

        @test NeuroCore.rotation2spatialorder(R) == (:right, :posterior, :inferior)
        @test NeuroCore.spatialorder2rotation((:right, :posterior, :inferior)) == R

        R = RotMatrix{3}([
            -1.0  0.0  0.0
            0.0  1.0  0.0
            0.0  0.0  1.0])
        @test NeuroCore.rotation2spatialorder(R) == (:right, :posterior, :inferior)
        @test NeuroCore.spatialorder2rotation((:right, :posterior, :inferior)) == R

        R = AffineMap(
                RotMatrix{3}([
                    1.000000 0.000000 0.000000
                    0.000000 -1.000000 0.000000
                    0.000000 0.000000 1.000000]),
                (1.0, 1.0, 1.0))

        @test NeuroCore.rotation2spatialorder(R) == (:left, :anterior, :inferior)
        @test NeuroCore.spatialorder2rotation((:left, :anterior, :inferior)) == R.linear

        R = AffineMap(
            RotMatrix{3}([
                1.000000 0.000000 0.000000
                0.000000 -1.000000 0.000000
                0.000000 0.000000 -1.000000]),
            [-90.0, -126.0, -72.0]
       )

        @test NeuroCore.rotation2spatialorder(R) == (:left, :anterior, :superior)
        @test NeuroCore.spatialorder2rotation((:left, :anterior, :superior)) == R.linear

        @test NeuroCore.rotation2spatialorder(affine_map(rand(2,2,2))) ==
              NeuroCore.rotation2spatialorder(affine_map(rand(2,2))) ==
              (:left, :posterior, :inferior)

    end

    @testset "LR MNI152" begin
        Q = AffineMap(SPQuat(0.0, 0.0, 0.0),
                  ntuple(_ -> 2.0, 3))
        @test NeuroCore.rotation2spatialorder(Q) == (:left, :posterior, :inferior)

        S = AffineMap(
            RotMatrix{3}([
                -2.000000 0.000000 0.000000
                 0.000000 2.000000 0.000000
                 0.000000 0.000000 2.000000]),
            (90.0, -126.0, -72.0)
        )
        @test NeuroCore.rotation2spatialorder(S) == (:right, :posterior, :inferior)
    end

    @testset "RL MNI152" begin
        R = AffineMap(
            RotMatrix{3}([
                2.000000 0.000000 0.000000
                0.000000 2.000000 0.000000
                0.000000 0.000000 2.000000]),
            (-90.0, -126.0, -72.0)
        )
        @test NeuroCore.rotation2spatialorder(R) == (:left, :posterior, :inferior)
    end

    @testset "Z stat" begin
        Q = AffineMap(SPQuat(0.0, 0.0, 0.0), (4.0, 4.0, 6.0))
        @test NeuroCore.rotation2spatialorder(Q) == (:left, :posterior, :inferior)
    end
end


@testset "quaternion <--> matrix" begin
    R = affine_map(rand(2,2,2))
    px = pixelspacing(rand(2,2,2))
    Q = NeuroCore.mat2quat(R, px)
    R2 = NeuroCore.quat2mat(Q, px)
    @test R.linear == R2.linear
end

@testset "2D orientation" begin
    Q = NeuroCore.mat2quat(rand(2,2))
    @test Q.linear.x == 0
    @test Q.linear.y == 0
    @test Q.linear.z == 0
end

@testset "Orientation errors" begin
    R = RotMatrix{3}([
        0.000000 0.000000 0.000000
        0.000000 -1.000000 0.000000
        0.000000 0.000000 -1.000000])
    @test_throws ErrorException NeuroCore.rotation2spatialorder(R)

    R = RotMatrix{3}([
        1.000000 0.000000 0.000000
        0.000000 0.000000 0.000000
        0.000000 0.000000 -1.000000])

    @test_throws ErrorException NeuroCore.rotation2spatialorder(R)
    R = RotMatrix{3}([
                -2.0                    6.714715653593746e-19  9.081024511081715e-18
                6.714715653593746e-19  1.9737114906311035    -0.35552823543548584
                8.25548088896093e-18   0.3232076168060303     2.171081781387329
            ])

    @test_throws ErrorException NeuroCore.number2dimname(9)

    @test_throws ErrorException NeuroCore.dimname2number(:foo)
end

