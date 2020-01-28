using Unitful: s, Hz, T, °
using NeuroCore: sampling_rate, volume_timing, duration, stop_time

time_array = NeuroArray(collect(1:10), (NeuroCore.Axis{:time}(range(1s, stop=10s, length=10)),))

time_array.volume_timing = [1s, 2s]

@test volume_timing(time_array) == [1s, 2s]

@test sampling_rate(time_array) == 1 / 1s

@test duration(time_array) == 9s

@test stop_time(time_array) == 10s

