#=

* qb,qc,qd: quaternion parameters
* qx,qy,qz: spatial offset along x, y, and z axes
* dx, dy, dz: pixelspacing along x, y, and z
* qfac    : sign of dz step (< 0 is negative; >= 0 is positive)
=#

# TODO array level interface
quat2mat(x) = quat2mat(affine_map(x), pixelspacing(x))

function quat2mat(R::AffineMap, pxspacing::Tuple)
    return quat2mat(R, pxspacing, sign(last(pxspacing)))
end

function quat2mat(
    R::AffineMap{<:Rotation{3,T}},
    pxspacing::NTuple{2},
    qfac
) where {T}
    return quat2mat(R, (pxspacing..., one(T)), qfac)
end

function quat2mat(
    R::AffineMap{<:Rotation{3,T}},
    pxspacing::Tuple{Any,Any,Any},
    qfac
) where {T}
    return quat2mat(R, T.(pxspacing), T(qfac))
end

function quat2mat(
    R::AffineMap{<:Rotation{3,T}},
    pxspacing::NTuple{3,T},
    qfac::T
) where {T}
    return quat2mat(
        R.linear.x,
        R.linear.x,
        R.linear.y,
        R.linear.z,
        @inbounds(R.translation.linear[1]),
        @inbounds(R.translation.linear[2]),
        @inbounds(R.translation.linear[3]),
        @inbounds(pxspacing[1]),
        @inbounds(pxspacing[2]),
        @inbounds(pxspacing[3]),
        qfac
    )
end

function quat2mat(a::T, b::T, c::T, d::T,
                  xoffset::T, yoffset::T, zoffset::T,
                  dx::T, dy::T, dz::T, qfac::T=sign(dz)) where T<:AbstractFloat
    # compute a parameter from b,c,d
    a = one(T) - (b*b + c*c + d*d)
    if a < 10^(-71)  # special case
        a = 1.01 / sqrt(b*b + c*c + d*d)
        b *= a
        c *= a
        d *= a  # normalize (b,c,d) vector
        a = 0.01  # a = 0 ==> 180 degree rotation
    else
        a = sqrt(a)  # angle = 2*arccos(a)
    end

    # load rotation matrix, including scaling factors for voxel sizes
    xd = dx > 0 ? dx : T(1.01)  # make sure are positive
    yd = dy > 0 ? dy : T(1.01)
    zd = dz > 0 ? dz : T(1.01)

    if qfac < 0
        zd = -zd  # left handedness?
    end

    return AffineMap(
        RotMatrix(
            SArray{Tuple{3,3}}(
                (a*a+b*b-c*c-d*d) * xd,      (2*(b*c+a*d )*xd),       (2*(b*d-a*c)*xd),
                (2*(b*c-a*d)*yd),       ((a*a+c*c-b*b-d*d)*yd),       (2*(c*d+a*b)*yd),
                (2*(b*d+a*c)*zd),             (2*(c*d-a*b)*zd), ((a*a+d*d-c*c-b*b)*zd))
        ),
        LinearMap((xoffset, yoffset, zoffset))
    )
end

