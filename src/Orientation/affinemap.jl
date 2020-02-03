function _affine_type(::Type{<:AbstractArray{T,N}}) where {T,N}
    return AffineMap{<:Rotation{N,Float64},SArray{Tuple{N},Float64,1,N}}
end
function affine_map(x::AbstractArray)
    return AffineMap(_spacedirection_to_rotation(RotMatrix, spacedirections(x)),
                     _pixelspacing_to_linearmap(pixelspacing(x)))
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
               0,        0, 1))
end

function _spacedirection_to_rotation(::Type{R}, sd::NTuple{3,NTuple{3,T}}) where {R,T}
    return @inbounds R(SMatrix{3,3,Float64,9}(
        sd[1][1], sd[2][1], sd[3][1],
        sd[1][2], sd[2][2], sd[3][2],
        sd[1][3], sd[2][3], sd[3][3]))
end

"Affine map relative to anatomical space."
@defprop AnatomicalAffine{:anataffine}::((x::Type{<:AbstractArray}) -> _affine_type(x)) begin
    @getproperty (x::AbstractArray) -> affine_map(x)
end

"Affine map relative to acquisition space."
@defprop AcquisitionAffine{:acqaffine}::((x::Type{<:AbstractArray}) -> _affine_type(x)) begin
    @getproperty (x::AbstractArray) -> affine_map(x)
end
