
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

"""
    coordinate_system!(x, val)

Set the coordinate space for `x` to `val`.
"""
function coordinate_system!(x::Any, val::CoordinateSystem)
    setter!(x, "coordinate_system", val, CoordinateSystem)
end

"""
    sform_code(x) -> CoordinateSystem

Code describing the orientation of the image.

Should only be one of following (although others are allowed):

* UnkownSpace
* AnatomicalSpace
* TalairachSpace
* MNI152Space
"""
sform_code(x::Any) = getter(x, "sform_code", CoordinateSystem, UnkownSpace)

"""
    sform_code!(x, val)

Set the `sform` coordinate space of `x` to `val`.
"""
sform_code!(x::Any, val::CoordinateSystem) = setter!(x, "sform_code", val, CoordinateSystem)

"""
    qform_code(x) -> CoordinateSystem

Code describing the orientation of the image in the scanner.

Should only be one of the following (although others are allowed):

* UnkownSpace
* ScannerSpace
"""
qform_code(x::Any) = getter(x, "sform_code", CoordinateSystem, UnkownSpace)

"""
    qform_code!(x, val)

Set the `qfrom` coordinate space of `x` to `val`.
"""
qform_code!(x::Any, val::CoordinateSystem) = setter!(x, "qform_code", val, CoordinateSystem)

"""
    qform(x) -> MMatrix{4,4,Float64,16}
"""
qform(x::Any) = getter(x, "qform", MMatrix{4,4,Float64,16}, i->default_affinemat(i))

qform!(x::Any, val::AbstractMatrix) = setter!(x, "qform", val, MMatrix{4,4,Float64,16})

"""
    sform(x) -> MMatrix{4,4,Float64,16}

The 4th column of the matrix is the offset of the affine matrix.
This is primarily included for the purpose of compatibility with DICOM formats, where the
"Image Position" stores the coordinates of the center of the first voxel
(see the [DICOM standard](http://dicom.nema.org/medical/dicom/current/output/chtml/part03/sect_C.7.6.2.html#sect_C.7.6.2.1.1) for more details;
Note, these values should be in interpreted as 'mm').
"""
sform(x::Any) = getter(x, "sform", MMatrix{4,4,Float64,16}, i-> affine_map(i))

sform!(x::Any, val::AbstractMatrix) = setter!(x, "sform", val, i -> affine_map(i))

function default_affinemat(x::Any)
    if sform_code(x) === UnkownSpace
        if qform_code(x) === UnkownSpace
            return _default_affinemat(x)
        else
            return qform(x)
        end
    else
        return sform(x)
    end
end

"""
    affine_map(x) -> MMatrix{4,4,Float64,16}

Returns affine matrix. For an instance that returns `spacedirections` this is
the corresponding tuple converted to an array.
"""
function affine_map(x)
    return _spacedirection_to_rotation(spacedirections(x)) ∘ _pixelspacing_to_linearmap(pixelspacing(x))
end

function _pixelspacing_to_linearmap(ps::NTuple{2,T}) where {T}
    return @inbounds LinearMap(SVector(Float64(ps[1]), Float64(ps[2]), 0.0))
end

function _pixelspacing_to_linearmap(ps::NTuple{3,T}) where {T}
    return @inbounds LinearMap(SVector(Float64(ps[1]), Float64(ps[2]), Float64(ps[3])))
end

function _spacedirection_to_rotation(::Type{R}, sd::NTuple{2,NTuple{2,T}}) where {R,T}
    return @inbounds R(SMatrix{3,3,Float64,9}(
        sd[1][1], sd[2][1], 0,
        sd[1][2], sd[2][2], 0,
               0,        0, 0))
end

function _spacedirection_to_rotation(::Type{R}, sd::NTuple{3,NTuple{3,T}}) where {R,T}
    return @inbounds R(SMatrix{3,3,Float64,9}(
        sd[1][1], sd[2][1], sd[3][1],
        sd[1][2], sd[2][2], sd[3][2],
        sd[1][3], sd[2][3], sd[3][3]))
end
