using MPI
using Statistics

# -------- NVTX --------
using NVTX
using Colors
# -------- NVTX --------

function compute_pi(N)
    M = 0 # number of darts that landed in the circle
    for i in 1:N
        if sqrt(rand()^2 + rand()^2) < 1.0
            M += 1
        end
    end
    return 4 * M / N
end

function main()
    MPI.Init()
    # -------- NVTX --------
    NVTX.enable_gc_hooks()
    # -------- NVTX --------
    comm = MPI.COMM_WORLD
    rank = MPI.Comm_rank(comm)
    nranks = MPI.Comm_size(comm)
    niter = 100
    N = 10_000_000
    if !isempty(ARGS)
        N = parse(Int, ARGS[1])
    end
    N_local = ceil(Int, N / nranks)

    times = zeros(niter)
    for i in 1:niter
        MPI.Barrier(comm)
        times[i] = MPI.Wtime()
        # -------- NVTX --------
        nvtx_range = NVTX.range_start(; message="compute pi", color=colorant"red")
        # -------- NVTX --------
        local_pi = compute_pi(N_local)
        pi_approx = MPI.Reduce(local_pi, +, 0, comm)
        if rank == 0
            pi_approx /= nranks
        end
        MPI.Barrier(comm)
        times[i] = MPI.Wtime() - times[i]
        # -------- NVTX --------
        NVTX.range_end(nvtx_range)
        # -------- NVTX --------

        if rank == 0
            println("(Iteration $i) π estimate: ", pi_approx)
        end
    end

    if rank == 0
        println("Minimum Δt (ms) = ", minimum(times) * 1e3)
        # println("Mean Δt (ms) = ", mean(times) * 1e3)
    end

    MPI.Finalize()
end

main()
