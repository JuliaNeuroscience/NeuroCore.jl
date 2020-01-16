
""""
    duration(x)

Duration of the event along the time axis.
"""
duration(x) = _duration(timeaxis(x))
_duration(ax) = stop_time(ax) - start_time(ax)

"""
    onset(x)

First time point along the time axis.
"""
onset(x) = first(timeaxis(x))

"""
    time_units(x)

Returns the units (i.e. Unitful.unit) the time axis is measured in. If not available
`nothing` is returned.
"""
time_units(x) = unit(eltype(timeaxis(x)))


"""
Number of samples per second.
"""
@defprop SamplingRate{:sampling_rate}

sampling_rate(x) = 1/step(timeaxis(x))

"""
Defines whether the recording is "continuous", "discontinuous" or "epoched";
this latter limited to time windows about events of interest (e.g., stimulus
presentations, subject responses etc.)
"""
@defprop TimeContinuity{:time_continuity}

