
const CLEXAMPLE = CoordinateList(:AC => (127.0, 119.0, 149.0),
                                 :PC => (128.0, 93.0, 141.0),
                                 :IH => (131.0, 114.0, 206.0))

img = NeuroMetaArray(rand(4,4))
props = NeuroMetadata()

for (property, default, valin, valout) in (
    (:acquisition_duration, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:anatomical_landmark_coordinates, CoordinateList(), CLEXAMPLE, CLEXAMPLE),
    #:AnatomicalLandmarkCoordinateSystem,
    #:AnatomicalLandmarkCoordinateUnits,
    #:AnatomicalLandmarkCoordinateSystemDescription,
    #:CogAtlasID,
    #:CogPOID,
    (:coil_combination_method, "rSOS", "", ""),
    (:contrast_bolus_ingredient, UnkownContrast, "IODINE", IODINE),
    (:delay_after_trigger, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:delay_time, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:device_serial_number, "00000", "11111", "11111"),
    (:dewar_position, OneIntDeg, 2, 2u"°"),
    (:dwell_time, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:echo_time, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:effective_echo_spacing, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:eeg_electrode_groups, Dict{Symbol,String}(), Dict(:grid1 => "10x8 grid on left temporal pole", :strip2 => "1x8 electrode strip on xxx"),  Dict(:grid1 => "10x8 grid on left temporal pole", :strip2 => "1x8 electrode strip on xxx")),
    (:eeg_ground, "", "mastoid", "mastoid"),
    (:eeg_placement_scheme, "", "surface strip and STN depth", "surface strip and STN depth"),
    (:electrical_stimulation, false, true, true),
    (:electrical_stimulation_parameters, "", "x", "x"),
    (:epoch_length, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:fiducial_description, "", "pre-auricular","pre-auricular"),
    (:flip_angle,  OneIntDeg, 2, 2u"°"),
    (:gradient_set_type, "", "gradient", "gradient"),
    (:head_coil_coordinates, CoordinateList(), CLEXAMPLE, CLEXAMPLE),
    #:head_coil_coordinate_system,
    #:head_coil_coordinate_system_description,
    #:head_coil_coordinate_units,
    (:institution_address, "", "x", "x"),
    (:institution_name, "", "x", "x"),
    (:institutional_department_name, "", "x", "x"),
    (:instructions, "", "x", "x"),
    (:intended_for, String[], ["x"], ["x"]),
    (:inversion_time, 1.0u"s", 2.0u"s", 2.0u"s"),
    (:magnetic_field_strength, 3.0u"T", 1.5u"T", 1.5u"T"),
    (:manufacturer, "", "x", "x"),
    (:manufacturer_model_name, "", "x", "x"),
    (:matrix_coil_mode, "", "x", "x"),
    (:mr_transmit_coil_sequence, "", "x", "x"),
    (:multiband_acceleration_factor, "", "x", "x"),
    (:negative_contrast, false, true, true),
    (:number_of_volumes_discarded_by_scanner, 0, 1, 1),
    (:number_of_volumes_discarded_by_user, 0, 1, 1),
    (:number_shots, 0, 1, 1),
    (:nonlinear_gradient_correction, false, true, true),
    (:parallel_acquisition_technique, "", "x", "x"),
    (:parallel_reduction_factor, 0, 1, 1),
    (:partial_fourier, 1.0, 2.0, 2.0),
    (:partial_fourier_direction, "", "COMBINATION", "COMBINATION"),
    (:phase_encoding_direction, ipos, 2, jpos),
    (:power_line_frequency, 1u"Hz", 2u"Hz", 2u"Hz"),
    (:pulse_sequence, "", "x", "x"),
    (:pulse_sequence_details, "", "x", "x"),
    (:pulse_sequence_type, "", "x", "x"),
    (:receive_coil_active_elements, "", "x", "x"),
    (:receive_coil_name, "", "x", "x"),
    (:recording_duration, 1u"s", 2u"s", 2u"s"),
    (:recording_type, "", "x", "x"),
    (:repetition_time, 1u"s", 2u"s", 2u"s"),
    (:sampling_frequency, 1u"Hz", 2u"Hz", 2u"Hz"),
    (:scan_options, Dict{Symbol,Any}(), Dict{Symbol,Any}(:randmeta => 1), Dict{Symbol,Any}(:randmeta => 1)),
    (:scanning_sequence, "", "x", "x"),
    (:sequence_name, "", "x", "x"),
    (:sequence_varient, "", "x", "x"),
    (:subject_artefact_description, "", "x", "x"),
    (:slice_encoding_direction, ipos, 2, jpos),
    (:slice_timing, F64Sec[], [2u"s"], [2u"s"]),
    (:software_versions, "", "x", "x"),
    #(:start_time, 1u"s", 2u"s", 2u"s"),
    (:station_name, "", "x", "x"),
    (:task_description, "", "x", "x"),
    (:task_name, "", "x", "x"),
    (:total_readout_time, 1u"s", 2u"s", 2u"s"),
    (:volume_timing, F64Sec[], [2u"s"], [2u"s"]),
   )
    @testset "$property" begin
        eval(:(fxn(x) = getproperty(x, $(QuoteNode(property)))))
        eval(:(fxn!(x, val) = setproperty!(x, $(QuoteNode(property)), val)))

        @test @inferred(fxn(img)) == default
        @test @inferred(fxn(props)) == default
        if !in(property, NeuroCore.NO_SET_PROPERTIES)
            fxn!(img, valin)
            fxn!(props, valin)
            @test @inferred(fxn(img)) == valout
            @test @inferred(fxn(props)) == valout
        end
    end
end
