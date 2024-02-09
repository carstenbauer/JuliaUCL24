using MPI
using Printf

"Function to be integrated (from 0 to 1). The analytic result is π."
f(x) = 4 * √(1 - x^2)

"Evaluate definite integral (from `a` to `b`) by using the trapezoidal rule."
function integrate_trapezoidal(a, b, n, h)
    y = (f(a) + f(b)) / 2.0
    for i in 1:n-1
        x = a + i * h
        y = y + f(x)
    end
    return y * h
end

function main()
    MPI.Init()

    comm  = MPI.COMM_WORLD
    nranks = MPI.Comm_size(comm)
    rank = MPI.Comm_rank(comm)

    # compute local integration interval etc.
    n_loc = 1000
    n_tot = n_loc * nranks
    h     = 1.0 / n_tot
    a_loc = rank * n_loc * h
    b_loc = a_loc + n_loc * h
    
    # perform local integration
    res_loc = integrate_trapezoidal(a_loc, b_loc, n_loc, h)

    # parallel reduction
    res = MPI.Reduce(res_loc, +, comm)
    
    # print result
    if 0 == rank
        @printf("π (numerical integration) ≈ %20.16f\n", res)
    end

    MPI.Finalize()
end

main()