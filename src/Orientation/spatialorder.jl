_spatialorder(R::AffineMap) = _spatialorder(R.linear)
function _spatialorder(R::Rotation{3,T}) where {T}
    # load column vectors for each (i,j,k) direction from matrix
    @inbounds begin
        xi = R[1,1]
        xj = R[1,2]
        xk = R[1,3]
        yi = R[2,1]
        yj = R[2,2]
        yk = R[2,3]
        zi = R[3,1]
        zj = R[3,2]
        zk = R[3,3]
    end

    # Normalize column vectors to get unit vectors along each ijk-axis
    # normalize i axis
    val = sqrt(xi*xi + yi*yi + zi*zi)
    if val == 0.0
        return 0  # stupid input
    end
    xi /= val
    yi /= val
    zi /= val

    # normalize j axis
    val = sqrt(xj*xj + yj*yj + zj*zj)
    if val == 0.0
        return 0  # stupid input
    end
    xj /= val
    yj /= val
    zj /= val

    # orthogonalize j axis to i axis, if needed
    val = xi*xj + yi*yj + zi* zj  # dot product between i and j
    if abs(val) > .0001
        xj -= val*xi
        yj -= val*yi
        zj -= val*zi

        val = sqrt(xj*xj + yj*yj + zj*zj)  # must renormalize
        if val == 0.0
            return 0  # j ws parallel to i?
        end
        xj /= val
        yj /= val
        zj /= val
    end

    # normalize k axis; if it is zero, make it the cross product i x j
    val = sqrt(xk*xk + yk*yk + zk*zk)
    if val == 0.0
        xk = yi*zj-zi*yj
        yk = zi*xj-zj*xi
        zk = xi*yj-yi*xj
    else
        xk = xk/val
        yk = yk/val
        zk = zk/val
    end

    # orthogonalize k to i
    val = xi*xk + yi*yk + zi*zk  # dot product between i and k
    if abs(val) > 0.0001
        xk -= val*xi
        yk -= val*yi
        zk -= val*zi

        # must renormalize
        val = sqrt(xk*xk + yk*yk + zk*zk)
        if val == 0.0
            return 0  # I think this is suppose to be an error output
        end
        xk /= val
        yk /= val
        zk /= val
    end

    # orthogonalize k to j */
    val = xj*xk + yj*yk + zj*zk  # dot product between j and k
   if abs(val) > 0.0001
       xk -= val*xj
       yk -= val*yj
       zk -= val*zj

       val = sqrt(xk*xk + yk*yk + zk*zk)
       if val == 0.0
           return 0  # bad
       end
       xk /= val
       yk /= val
       zk /= val
   end


    Q = T[[xi xj xk]
          [yi yj yk]
          [zi zj zk]]

    # at this point Q is the rotation matrix from the (i,j,k) to (x,y,z) axes
    detQ = det(Q)
    # if( detQ == 0.0 ) return ; /* shouldn't happen unless user is a DUFIS */

    # Build and test all possible +1/-1 coordinate permutation matrices P;
    # then find the P such that the rotation matrix M=PQ is closest to the
    # identity, in the sense of M having the smallest total rotation angle.

    # Despite the formidable looking 6 nested loops, there are
    # only 3*3*3*2*2*2 = 216 passes, which will run very quickly.
    vbest = T(-666)
    ibest = pbest=qbest=rbest= 1.0
    jbest = 2.0
    kbest = 3.0
    @inbounds for i in 1:3       # i = column number to use for row #1
        for j in 1:3             # j = column number to use for row #2
            if i == j
                continue
            end
            for k in 1:3     # k = column number to use for row #3
                if i == k || j ==k
                    continue
                end
                P = fill(0.0, 3, 3)
                for p in (-1, 1)           # p,q,r are -1 or +1
                    for q in (-1, 1)       # and go into rows 1,2,3
                        for r in (-1, 1)
                            P[1,i] = p
                            P[2,j] = q
                            P[3,k] = r
                            detP = det(P)  # sign of permutation
                            if detP * detQ < 0.0  # doesn't match sign of Q
                                continue
                            end
                            M = P * Q
                            # angle of M rotation = 2.0 * acos(0.5 * sqrt(1.0 + trace(M)))
                            # we want largest trace(M) == smallest angle == M nearest to I
                            val = M[1,1] + M[2,2] + M[3,3]
                            if val > vbest
                                vbest = val
                                ibest = i
                                jbest = j
                                kbest = k
                                pbest = p
                                qbest = q
                                rbest = r
                            end
                        end
                    end
                end
            end
        end
    end
    # At this point ibest is 1 or 2 or 3; pbest is -1 or +1; etc.

    # The matrix P that corresponds is the best permutation approximation
    # to Q-inverse; that is, P (approximately) takes (x,y,z) coordinates
    # to the (i,j,k) axes.

    # For example, the first row of P (which contains pbest in column ibest)
    # determines the way the i axis points relative to the anatomical
    # (x,y,z) axes.  If ibest is 2, then the i axis is along the y axis,
    # which is direction P2A (if pbest > 0) or A2P (if pbest < 0).

    # So, using ibest and pbest, we can assign the output code for
    # the i axis.  Mutatis mutandis for the j and k axes, of course.

    return (number2dimname(ibest*pbest),
            number2dimname(jbest*qbest),
            number2dimname(kbest*rbest))
end

function spatialorder2rotation(x::NTuple{3,Symbol})
    @inbounds spatialorder2rotation(first(x), x[2], last(x))
end

function spatialorder2rotation(x::Symbol, y::Symbol, z::Symbol)
    return RotMatrix{3}([
        dimname2number(x) 0                 0
        0                 dimname2number(y) 0
        0                 0                 dimname2number(z)
   ])
end

