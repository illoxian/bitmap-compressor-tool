using Distributions: rand
using BenchmarkTools: length, Benchmark, Trial
using BenchmarkTools
using Distributions
using LinearAlgebra
using BenchmarkPlots, StatsPlots

include("mydct.jl")
global res
global suite
global sort_res 
global sort_dct2
global sort_slow

function runTest(start=10, stop=100)
    square_dimensions = collect(range(start, stop, step=5))
    n_dimensions = length(square_dimensions)

    suite = BenchmarkGroup()
    rangearr = collect(range(1, n_dimensions, step=1))
    suite["dct2"] = BenchmarkGroup(sort(rangearr))
    suite["fast"] = BenchmarkGroup(sort(rangearr))
    suite["slow"] = BenchmarkGroup(sort(rangearr))
    # suite["slow"] = BenchmarkGroup(sort(rangearr))

    
    param = Exponential(100 * rand())
    for i = 1:n_dimensions
        m = rand(param, square_dimensions[i], square_dimensions[i])
        suite["dct2"][i] = @benchmarkable mDCT2n3($m)  evals=1 samples=5
        suite["fast"][i] = @benchmarkable dct($m) evals=1 samples=5
        if (mod(square_dimensions[i], 15) == 0)
            suite["slow"][i] = @benchmarkable mDCT2n4($m) evals=1 samples=1
        end
    end    

    # tune!(suite)
    global suite
    
    global res = run(suite; verbose=true)
    global sort_res = sort(collect(mean(res["fast"])), by = x->x[1])
    global sort_dct2 = sort(collect(mean(res["dct2"])), by = x->x[1])
    global sort_slow = sort(collect(mean(res["slow"])), by = x->x[1])

end


# i=1
# val = zeros(Int, n_dimensions)
# time_s = zeros(n_dimensions)
# for p in sort_res
#     val[i], time_s[i] = p
#     i = i+1
# end



