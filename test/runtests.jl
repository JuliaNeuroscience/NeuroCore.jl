using NeuroCore, Test, Unitful

@testset "InstitutionInformation" begin
    m = InstitutionInformation("", "", "")
    @test m.institution_name == ""
    @test m.institution_address == ""
    @test m.institutional_department_name == ""
end
