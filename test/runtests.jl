using NeuroCore, Test, Unitful, CoordinateTransformations, Documenter

using NeuroCore: SPQuat, RotMatrix, quat2mat, mat2quat, pixelspacing

include("semantic_positions.jl")
include("orientation.jl")
include("encoding_directions.jl")
include("time_tests.jl")
include("contrast_ingredient_tests.jl")

@testset "FieldProperties docs" begin
    doctest(NeuroCore; manual=false)
end

