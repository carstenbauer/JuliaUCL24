# Exercise: Distributed Monte Carlo (MPI)
#
# Calculate the value of π through parallel direct Monte Carlo.
#
# A unit circle is inscribed inside a unit square with side length 2 (from -1 to 1).
# The area of the circle is π, the area of the square is 4, and the ratio is π/4.
# This means that, if you throw N darts randomly at the square, approximately M=Nπ/4
# of those darts will land inside the unit circle.
#
# Throw darts randomly at a unit square and count how many of them ($M$) landed inside
# the unit circle. Approximate π ≈ 4M/N.
#
#
# ------ Tasks -------
#
# Based on the serial `compute_pi` (see below) we want to write a MPI program that computes π
# in parallel. The total number of dart throws is supposed to be (equally) distributed among
# the available MPI ranks (i.e. each rank runs `compute_pi` for a certain `N_local`)
#
# 1. Implement the parts marked by TODO below.
#
# 2. Run the code with the following command:
#
#                    mpiexecjl --project -n 8 julia mc_mpi.jl
#  
#    How does the performance of the MPI code compare to the Distributed.jl variant?

function compute_pi(N)
    M = 0 # number of darts that landed in the circle
    for i in 1:N
        if sqrt(rand()^2 + rand()^2) < 1.0
            M += 1
        end
    end
    return 4 * M / N
end

using MPI

function main()
    MPI.Init()
    comm = MPI.COMM_WORLD
    rank = MPI.Comm_rank(comm)
    nranks = MPI.Comm_size(comm)
    
    niter = 100                     # number of benchmark iterations
    N = 10_000_000                  # total number of dart throws
    N_local = ceil(Int, N / nranks) # local number of dart throws

    times = zeros(niter)
    for i in 1:niter # perform the benchmark niter times
        MPI.Barrier(comm)
        times[i] = MPI.Wtime() # timing start
        
        #
        # TODO: compute local pi estimate
        #
        local_pi = compute_pi(N_local)
        
        #
        # TODO: Use MPI.Reduce to sum up all rank-local π estimates.
        #       The reduction result will be available on rank 0.
        #       On rank 0, divide the result by nranks (to compute the average π estimate).
        #       The final result should be stored in the variable: pi_approx
        #
        pi_approx = MPI.Reduce(local_pi, +, 0, comm)
        if rank == 0
            pi_approx /= nranks
        end
        
        MPI.Barrier(comm)
        times[i] = MPI.Wtime() - times[i] # timing stop

        if rank == 0
            println("(Iteration $i) π estimate: ", pi_approx)
        end
    end

    if rank == 0
        println("Minimum Δt (ms) = ", minimum(times) * 1e3)
    end

    MPI.Finalize()
end

main()
