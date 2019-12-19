"""
    time_units(img)

Returns the units (i.e. Unitful.unit) the time axis is measured in. If not available
`nothing` is returned.
"""
time_units(x) = unit(eltype(timeaxis(x)))

"""
    start_time(x) -> F64Sec

Returns start time in seconds in relation to the start of acquisition of the first
data sample in the corresponding neural dataset (negative values are allowed).
"""
start_time(x) = first(timeaxis(x))


