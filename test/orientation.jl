# adapted from https://nifti.nimh.nih.gov/nifti-1/data
@testset "Orientations" begin
    @testset "Rotation matrices" begin
        R = RotMatrix{3}([
            -2.0                    6.714715653593746e-19  9.081024511081715e-18
            6.714715653593746e-19  1.9737114906311035    -0.35552823543548584
            8.25548088896093e-18   0.3232076168060303     2.171081781387329
        ])

        @test NeuroCore._spatialorder(R) == (:right, :posterior, :inferior)

        R = RotMatrix{3}([
            -1.0  0.0  0.0
            0.0  1.0  0.0
            0.0  0.0  1.0])

        @test NeuroCore._spatialorder(R) == (:right, :posterior, :inferior)
        @test NeuroCore.spatialorder2rotation((:right, :posterior, :inferior)) == R

        R = RotMatrix{3}([
            -1.0  0.0  0.0
            0.0  1.0  0.0
            0.0  0.0  1.0])
        @test NeuroCore._spatialorder(R) == (:right, :posterior, :inferior)
        @test NeuroCore.spatialorder2rotation((:right, :posterior, :inferior)) == R

        R = AffineMap(
                RotMatrix{3}([
                    1.000000 0.000000 0.000000
                    0.000000 -1.000000 0.000000
                    0.000000 0.000000 1.000000]),
                (1.0, 1.0, 1.0))

        @test NeuroCore._spatialorder(R) == (:left, :anterior, :inferior)
        @test NeuroCore.spatialorder2rotation((:left, :anterior, :inferior)) == R.linear

        R = AffineMap(
            RotMatrix{3}([
                1.000000 0.000000 0.000000
                0.000000 -1.000000 0.000000
                0.000000 0.000000 -1.000000]),
            [-90.0, -126.0, -72.0]
       )

        @test NeuroCore._spatialorder(R) == (:left, :anterior, :superior)
        @test NeuroCore.spatialorder2rotation((:left, :anterior, :superior)) == R.linear
    end

    @testset "LR MNI152" begin
        Q = AffineMap(SPQuat(0.0, 0.0, 0.0),
                  ntuple(_ -> 2.0, 3))
        @test NeuroCore._spatialorder(Q) == (:left, :posterior, :inferior)

        S = AffineMap(
            RotMatrix{3}([
                -2.000000 0.000000 0.000000
                0.000000 2.000000 0.000000
                0.000000 0.000000 2.000000]),
            (90.0, -126.0, -72.0)
        )
        @test NeuroCore._spatialorder(S) == (:right, :posterior, :inferior)
    end

    @testset "RL MNI152" begin
        R = AffineMap(
            RotMatrix{3}([
                2.000000 0.000000 0.000000
                0.000000 2.000000 0.000000
                0.000000 0.000000 2.000000]),
            (-90.0, -126.0, -72.0)
        )
        @test NeuroCore._spatialorder(R) == (:left, :posterior, :inferior)
    end

    @testset "Z stat" begin
        Q = AffineMap(SPQuat(0.0, 0.0, 0.0), (4.0, 4.0, 6.0))
        @test NeuroCore._spatialorder(Q) == (:left, :posterior, :inferior)
    end
end
