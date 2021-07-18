using Base: has_fast_linear_indexing, first_step_last_ascending
include("mydct.jl")

using MAT
using LinearAlgebra

matrix = [231 32 233 161 24 71 140 245
247 40 248 245 124 204 36 107
234 202 245 167 9 217 239 173
193 190 100 167 43 180 8 70
11 24 210 177 81 243 8 112
97 195 203 47 125 114 165 181
193 70 174 167 41 30 127 245
87 149 57 192 65 129 178 228]

MHmatrix = [
1.11e+03    4.40e+01    7.59e+01    -1.38e+02   3.50e+00    1.22e+02   1.95e+02    -1.01e+02
7.71e+01    1.14e+02    -2.18e+01   4.13e+01    8.77e+00    9.90e+01   1.38e+02    1.09e+01
4.48e+01    -6.27e+01   1.11e+02    -7.63e+01   1.24e+02    9.55e+01   -3.98e+01   5.85e+01
-6.99e+0    -4.02e+01   -2.34e+01   -7.67e+01   2.66e+01    -3.68e+01   6.61e+01    1.25e+02
-1.09e+0    -4.33e+01   -5.55e+01   8.17e+00    3.02e+01    -2.86e+01   2.44e+00    -9.41e+01
-5.38e+0    5.66e+01    1.73e+02    -3.54e+01   3.23e+01    3.34e+01   -5.81e+01   1.90e+01
7.88e+01    -6.45e+01   1.18e+02    -1.50e+01   -1.37e+02   -3.06e+01   -1.05e+02   3.98e+01
1.97e+01    -7.81e+01   9.72e-01    -7.23e+01   -2.15e+01   8.13e+01   6.37e+01    5.90e+00
]

cmatrix = [1118.7500000000002 44.02219262301787 75.91905032609426 -138.57241099707306 3.5000000000000284 122.07805518803062 195.04386762362958 -101.60490592795372; 77.1900790187901 114.86820590697009 -21.80144211456541 41.364135057036215 8.77720597607919 99.08296204231638 138.17151573211936 10.909279534077866; 44.83515365361005 -62.75244638273558 111.61411421683839 -76.37896579814382 124.42215968070717 95.59841936381827 -39.82879694884997 58.52376699413914; -69.98366474768355 -40.240894480279415 -23.497050834570445 -76.73205936982573 26.645774950452864 -36.83282895356625 66.18914845485334 125.42973061799121; -109.00000000000003 -43.34308566057378 -55.54369078865144 8.173470828327527 30.25000000000001 -28.660243733699012 2.4414982233614957 -94.14370254649862; -5.387835905170836 56.63450089125683 173.0215190411498 -35.42344938713219 32.38782492363563 33.45767275218619 -58.1167863718725 19.022561487011163; 78.84396931190855 -64.592409552383 118.67120305115003 -15.09048397585811 -137.31692787267204 -30.619666281198647 -105.11411421683843 39.813049706882936; 19.78824382848893 -78.18134089948808 0.9723118598351412 -72.34641800960696 -21.578163250360877 81.29990354778818 63.71037820527631 5.90618071066943]


v = [231 32 233 161 24 71 140 245]
c = [401.99 6.60002 109.167 -112.786 65.4074 121.831 116.656 28.8004]


function equalsMat(mat, emat)
    if round.(mat, digits=2)==round.(emat, digits=2)
        return true
    else
        return false
    end

end



function testDCT2(mat, cmat)
    if equalsMat(mDCT2n3(mat), cmat)
        return true
    else
        return false
    end
end

function testDCT2(mat)
    if equalsMat(mDCT2n3(mat), dct(mat))
        return true
    else
        return false
    end
end


function testiDCT2(cmat, mat)
    if equalsMat(miDCT2n3(cmat), mat)
        return true
    else
        return false
    end
end


function testiDCT2(cmat)
    if equalsMat(miDCT2n3(cmat), idct(cmat))
        return true
    else
        return false
    end
end






function testDCT(v, c)
    if equalsMat(mDCT(v), c)
        if equalsMat(v, miDCT(c))
            return true
        end
    else
        return false
    end
end




## VENGONO TESTATE TUTTE LE DCT

function testALL(mat, cmat)
    if (testDCT2(mat, cmat) && (testDCT2(mat))
        && testiDCT2(cmat, mat) && testiDCT2(cmat))
        return true
    else
        return false
    end
end

function testALL(mat)
    cmat = dct(mat)
    imat = idct(mat)
    return testALL(mat, cmat) && testALL(imat, mat)
end


if testALL(v,c)
    println("All vector test PASSED")
else
    println("All vector test NOT Passed")
end
if testALL(matrix, cmatrix)
    println("All matrix test PASSED")
else
    println("All matrix test NOT Passed")
end