struct CoordinateSystem{S} end

"""
    UnkownSpace
"""
const UnkownSpace = CoordinateSystem{:unkown}()


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


# TODO
"""
    slice_direction

Possible values: `i`, `j`, `k`, `i-`, `j-`, `k-` (the axis of the NIfTI data
along which slices were acquired, and the direction in which `SliceTiming` is
defined with respect to). `i`, `j`, `k` identifiers correspond to the first,
second and third axis of the data in the NIfTI file. A `-` sign indicates that
the contents of `SliceTiming` are defined in reverse order - that is, the first
entry corresponds to the slice with the largest index, and the final entry
corresponds to slice index zero. When present, the axis defined by
`SliceEncodingDirection` needs to be consistent with the ‘slice_dim’ field in
the NIfTI header. When absent, the entries in `SliceTiming` must be in the
order of increasing slice index as defined by the NIfTI header.                                                                                                                                                                                           |
"""
function slice_direction end


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
sform(x::Any) = getter(x, "sform", MMatrix{4,4,Float64,16}, i->default_affinemat(i))

sform!(x::Any, val::AbstractMatrix) = setter!(x, "sform", val, MMatrix{4,4,Float64,16})


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

function _default_affinemat(x::Any)
    _default_affinemat(spacedirections(x), pixelspacing(x))
end


function _default_affinemat(sd::NTuple{2,NTuple{2,T}}, ps::NTuple{2,T}) where T
    MMatrix{4,4,Float64,16}(sd[1][1], sd[2][1], 0, 0,
                            sd[1][2], sd[2][2], 0, 0,
                                   0,        0, 0, 0,
                               ps[1],    ps[2], 0, 0)
end

function _default_affinemat(sd::NTuple{3,NTuple{3,T}}, ps::NTuple{3,T}) where T
    MMatrix{4,4,Float64,16}(sd[1][1], sd[2][1], sd[3][1], 0,
                            sd[1][2], sd[2][2], sd[3][2], 0,
                            sd[1][3], sd[2][3], sd[3][3], 0,
                               ps[1],    ps[2],    ps[3], 0)
end

"""
    affine_matrix(x) -> MMatrix{4,4,Float64,16}

Returns affine matrix. For an instance that returns `spacedirections` this is
the corresponding tuple converted to an array.
"""
affine_matrix(x::Any) = getter(x, "affine_matrix", MMatrix{4,4,Float64,16}, i -> default_affinemat(i))


affine_matrix!(x::Any, val::AbstractMatrix) = setter!(x, "affine_matrix", val, MMatrix{4,4,Float64,16})
