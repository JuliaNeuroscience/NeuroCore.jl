struct CoordinateSystem{S} end

"""
    UnkownSpace
"""
const UnknownSpace = CoordinateSystem{:unknown}()

"""
    ScannerSpace

In scanner space.
"""
const ScannerSpace = CoordinateSystem{:scanner}()

"""
    AnatomicalSpace

equivalent of 'aligned' space in NIfTI standard.
"""
const AnatomicalSpace = CoordinateSystem{:anatomical}()

"""
    TailarachSpace

Tailarach space
"""
const TailarachSpace = CoordinateSystem{:tailarach}()

"""
    MNI152Space

MNI152 space
"""
const MNI152Space = CoordinateSystem{:MNI152}()

"""
    coordinate_system(x)

Return the coordinate space that `x` is in.
"""
coordinate_system(x::Any) = getter(x, "coordinatespace", CoordinateSystem, UnkownSpace)
# TODO : This probably shouldn't be mutable
function coordinate_system!(x::Any, val::CoordinateSystem)
    return setter!(x, "coordinate_system", val, CoordinateSystem)
end
