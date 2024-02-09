using BenchmarkTools
using PrettyTables
using Random
using ThreadPinning
using Base.Threads

if nthreads() != nnuma()
    println("ERROR: This exercise is supposed to be run with $(nnuma()) Julia threads! Aborting.")
    exit(42)
end

function axpy_kernel_dynamic!(y, a, x)
    #
    # TODO: Implement the AXPY kernel by looping over all elements of x/y.
    #       Parallelize the loop with `@threads :dynamic` (default).
    #       Use `@inbounds` to elide bound checks.
    #
    return nothing
end

function axpy_kernel_static!(y, a, x)
    #
    # TODO: Implement the AXPY kernel (similar to above) but this time use `@threads :static`.
    #       Use `@inbounds` to elide bound checks.
    #
    return nothing
end

function generate_input_data(; N, dtype, parallel=false, static=false, kwargs...)
    a = dtype(3.141)
    x = Vector{dtype}(undef, N)
    y = Vector{dtype}(undef, N)
    if !parallel
        rand!(x)
        rand!(y)
    else
        if !static
            #
            # TODO: Initialize `x` and `y` in parallel. Use `@threads :dynamic for ...`
            #       to write a random number of the correct datatype (`rand(dtype)`)
            #       into each array slot.
            #
        else
            #
            # TODO: Initialize `x` and `y` in parallel. Same as above but this time use
            #       static scheduling, i.e. `@threads :static for ...`.
            #
        end
    end
    return a,x,y
end

function measure_perf(; N=2^30, dtype=Float64, static=true, kwargs...)
    # input data
    a,x,y = generate_input_data(; N, dtype, static, kwargs...)

    # time measurement
    if static
        t = @belapsed axpy_kernel_static!($y,$a,$x) evals = 4 samples = 5
    else
        t = @belapsed axpy_kernel_dynamic!($y,$a,$x) evals = 4 samples = 5
    end
    
    # compute memory bandwidth and flops
    bytes     = 3 * sizeof(dtype) * N    # num bytes transferred in AXPY kernel (all iterations)
    flops     = 2 * N                    # num flops performed in AXPY kernel (all iterations)
    mem_rate  = bytes * 1e-9 / t         # memory bandwidth in GB/s
    flop_rate = flops * 1e-9 / t         # flops in GFLOP/s
    
    return mem_rate, flop_rate
end

function main()
    for static in (false, true)
        println("\nAXPY with @threads ", static ? ":static" : ":dynamic")
        membw_results = Matrix{Float64}(undef, 3, 2)
        for (i, pin) in enumerate((:cores, :sockets, :numa))
            for (j, parallel) in enumerate((false, true))
                pinthreads(pin)
                membw, flops = measure_perf(; parallel, static)
                membw_results[i, j] = round(membw; digits=2)
            end
        end

        # (pretty) printing
        println()
        pretty_table(membw_results;
            header=[":serial", ":parallel"],
            row_labels=[":cores", ":sockets", ":numa"],
            row_label_column_title="# Threads = $(nthreads())",
            title="Memory Bandwidth (GB/s)")
        println()
    end
end

@time main() # should take about 2 minutes