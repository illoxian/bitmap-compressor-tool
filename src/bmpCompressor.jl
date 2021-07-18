using LinearAlgebra
using FFTW
using ColorTypes
using Colors

function compress(file, f, d)
    
    image = load(file)
    print("loaded>> ")
    matrix = Float64.(Gray{Float64}.(image) ) * 255
    compressedMatrix = compressBMP(matrix,f,d)
    print("compressed>> ")
    compressedImage = Gray{Float64}.(compressedMatrix)
    compressedImage = Gray{N0f8}.(compressedImage )
    print("returning>> ")

    return compressedImage
end

function compressBMP(matrix, f, d)
    col = Int.(floor(  width(matrix) / f) * f)
    row = Int.(floor( height(matrix) / f) * f)
    pruned =  matrix[1:row, 1:col]
    final = ones(Float64, row, col)

    i = 1
    j = 1
    while i <= row
        while j <= col

            fi = i+f-1
            fj = j+f-1
            tmp = view(pruned, i:fi, j:fj)
            tmp = dct(tmp) 
            # tmp = dct(tmp, 2) 
            # tmp = dct(transpose(tmp), 2)
            # tmp = transpose(tmp)
            for k = 1:f
                for l = 1:f
                    if k+l-2 >= d 
                        tmp[k,l] = 0
                    end
                end
            end

            tmp = idct(tmp) 

            tmp = round.(tmp)

            tmp = map(x -> x <= 0 ? 0 : x, tmp)
            tmp = map(x -> x >= 255 ? 255 : x, tmp)
            tmp = map(x-> x/255, tmp)
            
            final[i:fi, j:fj] = tmp 

            j = j + f

        end
        i = i + f 
        j = 1

    end

    return final


end