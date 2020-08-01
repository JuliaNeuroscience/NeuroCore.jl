
"""
    spoiling_state(x)
    spoiling_state!(x, val)

Specifies whether the pulse sequence uses any type of spoiling stratey to suppress
transverse magnetization remaining after the readout.
"""
@defprop SpoilingState{:spoiling_state}::Bool

@enum SpoilingValues begin
    RF
    GRADIENT
    COMBINED
end

"""
    spoiling_type(x)
    spoiling_type!(x, val)

Specifies which spoiling method(s) are used by a spoiled sequence. Accepted values: `RF`, `GRADIENT` or `COMBINED`.
"""
@defprop SpoilingType{:spoiling_type}::SpoilingValues

"""
    spoiling_rf_phase_increment(x)
    spoiling_rf_phase_increment!(x, val)

The amount of incrementation described in degrees, which is applied to the
phase of the excitation pulse at each TR period for achieving RF spoiling.
"""
@defprop SpoilingRFPhaseIncrement{:spoiling_rf_phase_increment}::IntDegree

"""
    spoiling_gradient_moment(x)
    spoiling_gradient_moment!(x, val)

Zeroth moment of the spoiler gradient lobe in militesla times second per meter (mT.s/m).
"""
@defprop SpoilingGradientMoment{:spoiling_gradient_moment}::F64mTm

"""
    spoiling_gradient_duration(x)
    spoiling_gradient_duration!(x, val)

The duration of the spoiler gradient lobe in seconds. The duration of a
trapezoidal lobe is defined as the summation of ramp-up and plateu times.
"""
@defprop SpoilingGradientDuration{:spoiling_gradient_duration}::F64Second

"""
    SpoilingMetadata

Metadata structure for information concerning MRI sequence spoiling.

## Properties

$(GETPROPERTY)

$(SETPROPERTY)

"""
struct SpoilingMetadata{D,S}
    spoiling_state::Bool
    spoiling_type::SpoilingValues
    spoiling_gradient_moment::S
    spoiling_gradient_duration::S
end

@properties SpoilingMetadata begin
    spoiling_state(self) => :spoiling_state
    spoiling_type(self) => :spoiling_type
    spoiling_gradient_moment(self) => :spoiling_gradient_moment
    spoiling_gradient_duration(self) => :spoiling_gradient_duration
end

