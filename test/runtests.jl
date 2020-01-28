using NeuroCore, Test, Unitful, CoordinateTransformations

using NeuroCore: SPQuat, RotMatrix

include("semantic_positions.jl")
include("orientation.jl")
include("encoding_directions.jl")
include("axes_tests.jl")
include("time_tests.jl")

@testset "InstitutionInformation" begin
    m = InstitutionInformation("", "", "")
    @test m.institution_name == ""
    @test m.institution_address == ""
    @test m.institutional_department_name == ""
end

@testset "HardwareMetadata" begin
    m = HardwareMetadata("", "", "")
    @test m.device_serial_number == ""
    @test m.manufacturer_model_name == ""
    @test m.manufacturer == ""
end

