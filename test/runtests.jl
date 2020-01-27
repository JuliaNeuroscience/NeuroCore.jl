using NeuroCore, Test, Unitful, Rotations

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

R = RotMatrix{3}([
    -2.0                    6.714715653593746e-19  9.081024511081715e-18
    6.714715653593746e-19  1.9737114906311035    -0.35552823543548584
    8.25548088896093e-18   0.3232076168060303     2.171081781387329
])

NeuroCore._spatialorder(R)

@test NeuroCore._spatialorder(R) == (:right, :posterior, :inferior)

R = RotMatrix{3}([
    -1.0  0.0  0.0
    0.0  1.0  0.0
    0.0  0.0  1.0
])

@test NeuroCore._spatialorder(R) == (:right, :posterior, :inferior)
