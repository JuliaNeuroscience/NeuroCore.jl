# adapted from https://nifti.nimh.nih.gov/nifti-1/data
R = RotMatrix{3}([
    -2.0                    6.714715653593746e-19  9.081024511081715e-18
    6.714715653593746e-19  1.9737114906311035    -0.35552823543548584
    8.25548088896093e-18   0.3232076168060303     2.171081781387329
])

@test NeuroCore._spatialorder(R) == (:right, :posterior, :inferior)

R = RotMatrix{3}([
    -1.0  0.0  0.0
    0.0  1.0  0.0
    0.0  0.0  1.0
])

@test NeuroCore._spatialorder(R) == (:right, :posterior, :inferior)

R = RotMatrix{3}([
    -2.000000 0.000000 0.000000
    0.000000 2.000000 0.000000
    0.000000 0.000000 2.000000
])

@test NeuroCore._spatialorder(R) == (:right, :posterior, :inferior)

R = RotMatrix{3}([
    2.000000 0.000000 0.000000
    0.000000 2.000000 0.000000
    0.000000 0.000000 2.000000
])

@test NeuroCore._spatialorder(R) == (:left, :posterior, :inferior)

R = RotMatrix{3}([
    2.000000 0.000000 0.000000
    0.000000 -2.000000 0.000000
    0.000000 0.000000 2.000000
])

@test NeuroCore._spatialorder(R) == (:left, :anterior, :inferior)

R = RotMatrix{3}([
    2.000000 0.000000 0.000000
    0.000000 -2.000000 0.000000
    0.000000 0.000000 -2.000000
])

@test NeuroCore._spatialorder(R) == (:left, :anterior, :superior)
