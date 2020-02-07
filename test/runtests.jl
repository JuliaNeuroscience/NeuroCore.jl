using NeuroCore, Test, Unitful, CoordinateTransformations, Documenter

using NeuroCore: SPQuat, RotMatrix, quat2mat, mat2quat, pixelspacing

using NeuroCore: s, Hz, °, T

using NeuroCore.FieldProperties

@testset "dimensions" begin
    x = NeuroArray(rand(2,3,4,10);
                      left = 1:2,
                      anterior = 1:3,
                      superior=1:4,
                      time = range(1, stop=10, length=10));
    m = Metadata()
    m.duration = 2.0
    m.stop_time = 2.0
    m.sampling_rate = .5
    @test duration(m) == 2.0s
    @test stop_time(m) == 2.0s
    @test sampling_rate(m) == 0.5s^-1


    @test NeuroCore.spatial_offset(x) == (1, 1, 1)
    @test NeuroCore.spatial_eltype(x) == (Int64, Int64, Int64)
end

@testset "Magnetization Transfer" begin
    mt = NeuroCore.MagnetizationTransferMetadata(true, 1,2,3, :FERMI, 4)
    @test NeuroCore.mt_offset_frequency(mt) == 1.0Hz
    @test NeuroCore.mt_pulse_bandwidth(mt) == 2.0Hz
    @test NeuroCore.mt_npulses(mt) == 3
    @test NeuroCore.mt_pulse_duration(mt) == 4.0s
end

@testset "Spoiling Gradiant" begin
    m = Metadata()

    m.spoiling_rf_phase_increment = 1
    @test NeuroCore.spoiling_rf_phase_increment(m) == (1* °)

    m.spoiling_gradient_duration = 2
    @test NeuroCore.spoiling_gradient_duration(m) == 2s
end

@testset "General Parameters" begin
    m = Metadata()

    m.flip_angle = 1
    @test NeuroCore.flip_angle(m) == (1* °)

    m.magnetic_field_strength = 2
    @test NeuroCore.magnetic_field_strength(m) == (2*NeuroCore.Unitful.T)

    NeuroCore.slice_encoding_direction!(m, 1)
    @test slicedim(m) == 1

    NeuroCore.phase_encoding_direction!(m, 3)
    @test phasedim(m) == 3

end

@testset "Imaging Time" begin
    m = Metadata()

    m.echo_time = 1
    @test NeuroCore.echo_time(m) == 1.0s

    m.inversion_time = 2
    @test NeuroCore.inversion_time(m) == 2.0s

    # TODO needs to be an array
    #m.slice_timing = 3
    #@test NeuroCore.slice_timing(m) == 3.0s

    m.dwell_time = 4
    @test NeuroCore.dwell_time(m) == 4.0s

    m.acquisition_duration = 5
    @test NeuroCore.acquisition_duration(m) == 5.0s

    m.delay_after_trigger = 6
    @test NeuroCore.delay_after_trigger(m) == 6.0s

    # TODO needs to be an array
    #m.volume_timing = 7
    #@test NeuroCore.volume_timing(m) == 7.0s


    m.repetition_time = 8
    @test NeuroCore.repetition_time(m) == 8.0s

    m.effective_echo_spacing = 9
    @test NeuroCore.effective_echo_spacing(m) == 9.0s

    m.total_readout_time = 10
    @test NeuroCore.total_readout_time(m) == 10.0s
end


include("semantic_positions.jl")
include("orientation.jl")
include("encoding_directions.jl")
include("time_tests.jl")
include("contrast_ingredient_tests.jl")

@testset "docs" begin
    doctest(NeuroCore; manual=false)
end

