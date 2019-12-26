const PROPERTIES = [
    :acquisition_duration,
    :anatomical_landmark_coordinates,
    :anatomical_landmark_coordinate_system,
    :anatomical_landmark_coordinate_units,
    :anatomical_landmark_coordinate_system_description,
    :CogAtlasID,
    :CogPOID,
    :coil_combination_method,
    :contrast_bolus_ingredient,
    :delay_after_trigger,
    :delay_time,
    :device_serial_number,
    :dewar_position,
    :dwell_time,
    :echo_time,
    :effective_echo_spacing,
    :eeg_electrode_groups,
    :eeg_ground,
    :eeg_placement_scheme,
    :electrical_stimulation,
    :electrical_stimulation_parameters,
    :epoch_length,
    :fiducial_description,
    :flip_angle,
    :gradient_set_type,
    :head_coil_coordinates,
    :head_coil_coordinate_system,
    :head_coil_coordinate_system_description,
    :head_coil_coordinate_units,
    :institution_address,
    :institution_name,
    :institutional_department_name,
    :instructions,
    :intended_for,
    :inversion_time,
    :magnetic_field_strength,
    :manufacturer,
    :manufacturer_model_name,
    :matrix_coil_mode,
    :mr_transmit_coil_sequence,
    :multiband_acceleration_factor,
    :negative_contrast,
    :number_of_volumes_discarded_by_scanner,
    :number_of_volumes_discarded_by_user,
    :number_shots,
    :nonlinear_gradient_correction,
    :parallel_acquisition_technique,
    :parallel_reduction_factor,
    :partial_fourier,
    :partial_fourier_direction,
    :phase_encoding_direction,
    :power_line_frequency,
    :pulse_sequence,
    :pulse_sequence_details,
    :pulse_sequence_type,
    :receive_coil_active_elements,
    :receive_coil_name,
    :recording_duration,
    :recording_type,
    :repetition_time,
    :sampling_frequency,
    :scan_options,
    :scanning_sequence,
    :sequence_name,
    :sequence_varient,
    :subject_artefact_description,
    :slice_encoding_direction,
    :slice_timing,
    :software_versions,
    :start_time,
    :station_name,
    :task_description,
    :task_name,
    :total_readout_time,
    :volume_timing,
   ]

NO_SET_PROPERTIES = [:anatomical_landmark_coordinate_system,
                     :anatomical_landmark_coordinate_units,
                     :head_coil_coordinate_system,
                     :head_coil_coordinate_units,
                     :start_time,
                    ]

function generate_getproperty(props)
    e = :(return getindex(properties(x),  s))
    for p in props
        e = :(if $(Expr(:call, :(===), :s, QuoteNode(p)))
              return $p(x)
          else
              $e
          end
         )
    end
    @eval begin
        function neuroproperty(x, s::Symbol)
            Base.@_inline_meta
            $e
        end
    end
    return nothing
end
generate_getproperty(PROPERTIES)

function generate_setproperty(props, noprops)
    e = :(return setindex!(properties(x), val, s))
    for p in props
        if p in noprops
            continue
        else
            pp = Symbol(p, :!)
            e = :(if $(Expr(:call, :(===), :s, QuoteNode(p)))
                  return $pp(x, val)
              else
                  $e
              end
             )
        end
    end
    @eval begin
        function neuroproperty!(x, s::Symbol, val)
            Base.@_inline_meta
            $e
        end
    end
    return nothing
end
generate_setproperty(PROPERTIES, NO_SET_PROPERTIES)
