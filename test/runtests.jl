using NeuroCore, Test, Unitful, Rotations

include("orientation.jl")

#=
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
=#

