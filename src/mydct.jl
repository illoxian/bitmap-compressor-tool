using LinearAlgebra: Matrix, sqrt
using LinearAlgebra
using FFTW
using MAT

function alpha1D(k, N)
    if k>0
        return sqrt(2/N)
    else
        return sqrt(1/N)
    end
end

function alpha2D(k, l, N)
    if k==0 && l==0
        return 1/N
    elseif l==0 || k==0
        return sqrt(2)/N
    else
        return 2/N
    end
end



function mDCT(v)
    N = length(v)
    c = zeros(1, N)

    for k = 0:(N-1)
        sum = 0.0
        for i = 0:(N-1)
            sum = sum + v[i+1] * cos(k*pi*((2*i+1)/(2*N)))
        end
        c[k+1] = alpha1D(k,N) * sum
    end
    return c
end


function miDCT(c)
    N = length(c)
    v = zeros(1,N)
    for j = 0:(N-1)
        for k = 0:(N-1)
            ak= alpha1D(k,N)
            v[j+1] = v[j+1] +(c[k+1] * ak * cos(pi*k*((2*j)+1)/(2*N)))
        end
    end
    return v
end

function mDCT2n4(matrix)
    N = size(matrix,1)
    M = size(matrix,1)

    cmat = zeros(N, M)

    for k = 0:(N-1)
        for l = 0:(M-1)
            sum = 0
            for i = 0:(N-1)
                for j = 0:(M-1)
                    sum = sum + (matrix[i+1, j+1] * cos(k*pi*((2*i+1)/(2*N))) * cos(l*pi*((2*j+1)/(2*M))))
                end
            end
            cmat[k+1, l+1] = alpha2D(k,l,N) * sum
        end
    end
    return cmat
end


function miDCT2n4(cmat)
    N = size(matrix,1)
    M = size(matrix,2)
    matrix = zeros(N, M)
    sum = 0
    for i = 0:(N-1)
        for j = 0:(M-1)
            for k = 0:(N-1)
                for l = 0:(M-1)
                    ak2 = alpha2D(k,l,N)
                    matrix[i+1, j+1] = matrix[i+1, j+1] + (cmat[k+1, l+1] *ak2 *cos(pi*k*((2*i)+1)/(2*N)) * cos(pi*l*((2*j)+1)/(2*M)))
                end
            end
        end
    end
    return matrix
end


function mDCT2n3(matrix)
    N = size(matrix,1)
    M = size(matrix,2)
    cmat = zeros(N,M)


    for j = 0:(N-1)
        ind = j+1
        cmat[ind, :] = mDCT(matrix[ind,:])
    end
    cmatT = transpose(cmat)
    for k = 0:(M-1)
        cmatT[k+1,:] = mDCT(cmatT[k+1,:]) 
    end
    cmat = transpose(cmatT)
    return cmat 
end

function miDCT2n3(cmat)
    N = size(cmat,1)
    M = size(cmat,2)
    matrix = zeros(N,M)
    matrixT = zeros(N,M)

    for j = 0:(N-1)
        matrix[j+1,:] = miDCT(cmat[j+1,:])
    end
    matrixT = transpose(matrix)
    for k = 0:(M-1)
        matrixT[k+1,:] = miDCT(matrixT[k+1,:])
    end
    matrix = transpose(matrixT)
    return matrix
end


