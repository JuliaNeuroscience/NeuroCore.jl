
function polar(A::StaticMatrix{3,3,T}) where {T}
    X = similar(A)
    Z = similar(A)
    k = 0
    gam = det(X)
    while gam == 0.0  # perturb matrix
        gam = 0.00001 * (0.001 + rownorm(X))
        X[1,1] += gam
        X[2,2] += gam
        X[3,3] += gam
        gam = det(X)
    end
    dif = sum(Z .- X)
    while true
        Y = inv(X)
        if dif > 0.3  # far from convergence
            alp = sqrt(rownorm(X) * colnorm(X))
            bet = sqrt(rownorm(Y) * colnorm(Y))
            gam = sqrt(bet / alp)
            gmi = one(T) /gam
        else
            gam = gmi = one(T)
        end
        Z = SMatrix{3,3}(
            0.5 * (gam*X[1,1] + gmi*Y[1,1]), 0.5 * (gam*X[1,2] + gmi*Y[2,1]), 0.5 * (gam*X[1,3] + gmi*Y[3,1]),
            0.5 * (gam*X[2,1] + gmi*Y[1,2]), 0.5 * (gam*X[2,2] + gmi*Y[2,2]), 0.5 * (gam*X[2,3] + gmi*Y[3,2]),
            0.5 * (gam*X[3,1] + gmi*Y[1,3]), 0.5 * (gam*X[3,2] + gmi*Y[2,3]), 0.5 * (gam*X[3,3] + gmi*Y[3,3])
        )
        dif = sum(Z .- X)
        k = k+1
        if k > 100 || dif < 0.0000001  # convergence or exhaustion
            break
        end
        X = Z
    end
    return Z
end

@inline function colnorm(A::StaticMatrix{3,3,Float64})
    r1 = abs(A[1,1]) + abs(A[2,1]) + abs(A[3,1])
    r2 = abs(A[1,2]) + abs(A[2,2]) + abs(A[3,2])
    r3 = abs(A[1,3]) + abs(A[2,3]) + abs(A[3,3])

    if r1 < r2
        if r2 < r3
            return r3
        else
            return r2
        end
    else
        if r1 < r3
            return r3
        else
            return r1
        end
    end
end

@inline function rownorm(A::StaticMatrix{3,3,Float64})
    r1 = abs(A[1,1]) + abs(A[1,2]) + abs(A[1,3])
    r2 = abs(A[2,1]) + abs(A[2,2]) + abs(A[2,3])
    r3 = abs(A[3,1]) + abs(A[3,2]) + abs(A[3,3])

    if r1 < r2
        if r2 < r3
            return r3
        else
            return r2
        end
    else
        if r1 < r3
            return r3
        else
            return r1
        end
    end
end

