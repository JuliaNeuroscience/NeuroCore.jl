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

    @test NeuroCore.spatial_offset(x) == (1, 1, 1)
    @test NeuroCore.spatial_eltype(x) == (Int64, Int64, Int64)
end

@testset "Magnetization Transfer" begin
    mt = NeuroCore.MagnetizationTransferMetadata(true, 1,2,3, :FERMI, 4)
    @test @inferred(NeuroCore.mt_offset_frequency(mt)) == 1.0Hz
    @test @inferred(NeuroCore.mt_pulse_bandwidth(mt)) == 2.0Hz
    @test @inferred(NeuroCore.mt_npulses(mt)) == 3
    @test @inferred(NeuroCore.mt_pulse_duration(mt)) == 4.0s

    #=
    @test @inferred(mt_offset_frequency(mt)) == 1.0Hz
    @test @inferred(mt_pulse_bandwidth(mt)) == 2.0Hz
    @test @inferred(mt_npulses(mt)) == 3
    @test @inferred(mt_pulse_duration(mt)) == 4.0s
    =#
end

@testset "Spoiling Gradiant" begin
    m = Metadata()

    @testset "spoiling_rf_phase_increment" begin
        m.spoiling_rf_phase_increment = 1
        @test @inferred(NeuroCore.spoiling_rf_phase_increment(m)) == (1*°)
        NeuroCore.spoiling_rf_phase_increment!(m, 1)
        @test m.spoiling_rf_phase_increment == (1*°)
    end

    @testset "duration" begin
        m.duration = 2.0
        @test @inferred(duration(m)) == 2.0s
        duration!(m, 2)
        @test m.duration == 2.0s
    end

    @testset "stop_time" begin
        m.stop_time = 2.0
        @test @inferred(stop_time(m)) == 2.0s
        stop_time!(m, 2)
        m.stop_time == 2.0s
    end

    @testset "sampling_rate" begin
        m.sampling_rate = .5
        @test @inferred(sampling_rate(m)) == 0.5s^-1
        sampling_rate!(m, .5)
        @test m.sampling_rate == 0.5s^-1
    end

    @testset "spoiling_gradient_duration" begin
        m.spoiling_gradient_duration = 2
        @test @inferred(NeuroCore.spoiling_gradient_duration(m)) == 2s
        NeuroCore.spoiling_gradient_duration!(m, 2)
        @test m.spoiling_gradient_duration == 2s
    end

    @testset "flip_angle" begin
        m.flip_angle = 1
        @test @inferred(NeuroCore.flip_angle(m)) == (1* °)
        NeuroCore.flip_angle!(m, 1)
        @test m.flip_angle == (1*°)
    end

    @testset "magnetic_field_strength" begin
        m.magnetic_field_strength = 2
        @test @inferred(NeuroCore.magnetic_field_strength(m)) == (2*NeuroCore.Unitful.T)
        NeuroCore.magnetic_field_strength!(m, 2)
        @test m.magnetic_field_strength == (2*NeuroCore.Unitful.T)
    end

    @testset "slice_encoding_direction" begin
        NeuroCore.slice_encoding_direction!(m, 1)
        @test @inferred(slicedim(m)) == 1
        slicedim!(m, 1)
        @test m.slicedim == 1
    end

    @testset "phase_encoding_direction" begin
        NeuroCore.phase_encoding_direction!(m, 3)
        @test @inferred(phasedim(m)) == 3
        phasedim!(m, 3)
        @test m.phasedim == 3
    end

    @testset "echo_time" begin
        m.echo_time = 1
        @test NeuroCore.echo_time(m) == 1.0s
        NeuroCore.echo_time!(m, 1)
        @test m.echo_time == 1.0s
    end

    @testset "inversion_time" begin
        m.inversion_time = 2
        @test NeuroCore.inversion_time(m) == 2.0s
        NeuroCore.inversion_time!(m, 2)
        @test m.inversion_time == 2.0s
    end

    # TODO needs to be an array
    #m.slice_timing = 3
    #@test NeuroCore.slice_timing(m) == 3.0s

    @testset "dwell_time" begin
        m.dwell_time = 4
        @test @inferred(NeuroCore.dwell_time(m)) == 4.0s
        NeuroCore.dwell_time!(m, 4)
        @test m.dwell_time == 4.0s
    end

    @testset "acquisition_duration" begin
        m.acquisition_duration = 5
        @test @inferred(NeuroCore.acquisition_duration(m)) == 5.0s
        NeuroCore.acquisition_duration!(m, 5)
        @test m.acquisition_duration == 5.0s
    end

    @testset "delay_after_trigger" begin
        m.delay_after_trigger = 6
        @test @inferred(NeuroCore.delay_after_trigger(m)) == 6.0s
        NeuroCore.delay_after_trigger!(m, 6)
        @test m.delay_after_trigger == 6.0s
    end

    # TODO needs to be an array
    #m.volume_timing = 7
    #@test NeuroCore.volume_timing(m) == 7.0s


    @testset "repetition_time" begin
        m.repetition_time = 8
        @test @inferred(NeuroCore.repetition_time(m)) == 8.0s
        NeuroCore.repetition_time!(m, 8)
        @test m.repetition_time == 8.0s
    end

    @testset "effective_echo_spacing" begin
        m.effective_echo_spacing = 9
        @test @inferred(NeuroCore.effective_echo_spacing(m)) == 9.0s
        NeuroCore.effective_echo_spacing!(m, 9)
        @test m.effective_echo_spacing == 9.0s
    end

    @testset "total_readout_time" begin
        m.total_readout_time = 10
        @test @inferred(NeuroCore.total_readout_time(m)) == 10.0s
        NeuroCore.total_readout_time!(m, 10)
        @test m.total_readout_time == 10.0s
    end

    @testset "high_cutoff" begin
        m.high_cutoff = 10
        @test @inferred(NeuroCore.high_cutoff(m)) == 10.0Hz
        NeuroCore.high_cutoff!(m, 10)
        @test m.high_cutoff == 10.0Hz
    end

    @testset "low_cutoff" begin
        m.low_cutoff = 10
        @test @inferred(NeuroCore.low_cutoff(m)) == 10.0Hz
        NeuroCore.low_cutoff!(m, 10)
        @test m.low_cutoff == 10.0Hz
    end

    @testset "notch_filter" begin
        m.notch_filter = 10
        @test @inferred(NeuroCore.notch_filter(m)) == 10.0Hz
        NeuroCore.notch_filter!(m, 10)
        @test m.notch_filter == 10.0Hz
    end

    @testset "power_line_frequency" begin
        m.power_line_frequency = 5
        @test @inferred(NeuroCore.power_line_frequency(m)) == 5.0Hz
        NeuroCore.power_line_frequency!(m, 10)
        @test m.power_line_frequency == 10.0Hz
    end

    @testset "dewar_position" begin
        m.dewar_position = 1
        @test @inferred(NeuroCore.dewar_position(m)) == (1* °)
        NeuroCore.dewar_position!(m, 1)
        @test m.dewar_position == (1* °)
    end

    @testset "epoch_length" begin
        m.epoch_length = 1
        @test @inferred(NeuroCore.epoch_length(m)) == 1.0s
        NeuroCore.epoch_length!(m, 1)
        @test m.epoch_length == 1.0s
    end
end


include("semantic_positions.jl")
include("orientation.jl")
include("encoding_directions.jl")
include("time_tests.jl")
include("contrast_ingredient_tests.jl")

@testset "docs" begin
    doctest(NeuroCore; manual=false)
end

