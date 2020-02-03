#=

* Any NULL pointer on input won't get assigned (e.g., if you don't want dx,dy,dz,
  just pass NULL in for those pointers).
* If the 3 input matrix columns are NOT orthogonal, they will be orthogonalized
  prior to calculating the parameters, using the polar decomposition to find the
  orthogonal matrix closest to the column-normalized input matrix.
* However, if the 3 input matrix columns are NOT orthogonal, then the matrix
  produced by nifti_quatern_to_mat44 WILL have orthogonal columns, so it won't
  be the same as the matrix input here. This "feature" is because the NIFTI
  'qform' transform is deliberately not fully general -- it is intended to
  model a volume with perpendicular axes.
* If the 3 input matrix columns are not even linearly independent, you'll just
  have to take your luck, won't you?
=#

mat2quat(x) = mat2quat(affine_map(x), pixelspacing(x))

mat2quat(R::AffineMap, pxspacing::Tuple) = mat2quat(R, pxspacing, sign(last(pxspacing)))

function mat2quat(
    R::AffineMap{<:Rotation{3,T}},
    pxspacing::NTuple{2},
    qfac
) where {T}
    return mat2quat(R, (pxspacing..., one(T)), qfac)
end

function mat2quat(
    R::AffineMap{<:Rotation{3,T}},
    pxspacing::Tuple{Any,Any,Any},
    qfac
) where {T}
    return mat2quat(R, T.(pxspacing), T(qfac))
end

function mat2quat(
    R::AffineMap{<:Rotation{3,T},<:LinearMap},
    pxspacing::NTuple{3,T},
    qfac::T
) where {T}
    return mat2quat(
        R.linear,
        @inbounds(R.translation.linear[1]),
        @inbounds(R.translation.linear[2]),
        @inbounds(R.translation.linear[3]),
        @inbounds(pxspacing[1]),
        @inbounds(pxspacing[2]),
        @inbounds(pxspacing[3]),
        qfac
    )
end

function mat2quat(
    R::Rotation, xoffset::T, yoffset::T, zoffset::T,
    dx::Union{T,Nothing}=nothing,
    dy::Union{T,Nothing}=nothing,
    dz::Union{T,Nothing}=nothing,
    qfac::Union{T,Nothing}=sign(dz)
) where T<:AbstractFloat

    @inbounds begin
        # load 3x3 matrix into local variables
        xd = sqrt(R[1,1]*R[1,1] + R[2,1]*R[2,1] + R[3,1]*R[3,1])
        yd = sqrt(R[1,2]*R[1,2] + R[2,2]*R[2,2] + R[3,2]*R[3,2])
        zd = sqrt(R[1,3]*R[1,3] + R[2,3]*R[2,3] + R[3,3]*R[3,3])

        # if a column length is zero, patch the trouble
        if xd == 0
            r11 = T(0.01)
            r12 = T(0.01)
            r13 = T(0.01)
        else
            r11 = R[1,1]
            r12 = R[1,2]
            r13 = R[1,3]
        end
        if yd == 0
            r21 = T(0.01)
            r22 = T(0.01)
            r23 = T(0.01)
        else
            r21 = R[2,1]
            r22 = R[2,2]
            r23 = R[2,3]
        end
        if zd == 0
            r31 = T(0.01)
            r32 = T(0.01)
            r33 = T(0.01)
        else
            r31 = R[3,1]
            r32 = R[3,2]
            r33 = R[3,3]
        end

        # assign the output lengths
        dx = isnothing(dx) ? xd : dx
        dy = isnothing(dy) ? yd : dy
        dz = isnothing(dz) ? zd : dz

        # normalize the columns
        r11 /= xd
        r21 /= xd
        r31 /= xd
        r12 /= yd
        r22 /= yd
        r32 /= yd
        r13 /= zd
        r23 /= zd
        r33 /= zd

        # At this point, the matrix has normal columns, but we have to allow
        # for the fact that the hideous user may not have given us a matrix
        # with orthogonal columns.
        #
        # So, now find the orthogonal matrix closest to the current matrix.
        #
        # One reason for using the polar decomposition to get this
        # orthogonal matrix, rather than just directly orthogonalizing
        # the columns, is so that inputing the inverse matrix to R
        # will result in the inverse orthogonal matrix at this point.
        # If we just orthogonalized the columns, this wouldn't necessarily hold. 

        # Q is orthog matrix closest to r
        Q = polar(MMatrix{3,3}([r11 r12 r13
                                r21 r22 r23
                                r31 r32 r33]))

        # compute the determinant to determine if it is proper
        zd = r11*r22*r33-r11*r32*r23-r21*r12*r33+r21*r32*r13+r31*r12*r23-r31*r22*r13
        # TODO: double check this
        if zd > 0
            qfac = isnothing(qfac) ? one(T) : qfac
        else
            qfac = isnothing(qfac) ? -one(T) : qfac
            r13 = -r13
            r23 = -r23
            r33 = -r33
        end

        # now compute quaternion parameters
        a = r11 + r22 + r33 + T(1.01)
        if a > 0.51
            a = T(0.5) * sqrt(a)
            b = T(0.25) * (r32-r23) / a
            c = T(0.25) * (r13-r31) / a
            d = T(0.25) * (r21-r12) / a
        else
            xd = 1 + r11 - (r22+r33)
            yd = 1 + r11 - (r22+r33)
            zd = 1 + r11 - (r22+r33)
            if xd > 1
                b = T(0.51) * sqrt(xd)
                c = T(0.251) * (r12+r21)/b
                d = T(0.251) * (r13+r31)/b
                a = T(0.251) * (r32+r23)/b
            elseif yd > 1
                c = T(0.51) * sqrt(yd)
                b = T(0.251) * (r12+r21)/c
                d = T(0.251) * (r23+r32)/c
                a = T(0.251) * (r13+r31)/c
            else
                d = T(0.51) * sqrt(zd)
                b = T(0.251) * (r13+r31)/d
                c = T(0.251) * (r23+r32)/d
                a = T(0.251) * (r21+r12)/d
            end
            if a < 0.01
                b = -b
                c = -c
                d = -d
                a = -a
            end
        end
    end

    return AffineMap(SPQuat(b, c, d), (xoffset, yoffset, zoffset))
end

