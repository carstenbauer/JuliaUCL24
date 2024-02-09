using MPI
using Random

function diffusion_1d(; n=1_000, nsteps=5_000_000)
    comm = MPI.COMM_WORLD
    rank = MPI.Comm_rank(comm)
    nranks = MPI.Comm_size(comm)

    # n regular cells (indices: 2:n+1)
    # 2 "ghost cells"/"halo cells" (indices: 1 and n+2)
    Random.seed!(42)
    f = rand(n + 2)
    f_prev = rand(n + 2)
    c = 0.001 # DΔt/h²

    # periodic boundary conditions
    left_rank = mod(rank - 1, nranks)
    right_rank = mod(rank + 1, nranks)
    
    function diffusion_stencil!(f, f_prev, c, i)
        f[i] = f_prev[i] + c * (f_prev[i-1] - 2 * f_prev[i] + f_prev[i+1])
    end

    for step in 1:nsteps
        # blocking communication
        if iseven(rank)
            MPI.Send(@view(f_prev[n+1]), comm; dest=right_rank)
            MPI.Recv!(@view(f_prev[1]), comm; source=left_rank)
            MPI.Send(@view(f_prev[2]), comm; dest=left_rank)
            MPI.Recv!(@view(f_prev[n+2]), comm; source=right_rank)
        else
            MPI.Recv!(@view(f_prev[1]), comm; source=left_rank)
            MPI.Send(@view(f_prev[n+1]), comm; dest=right_rank)
            MPI.Recv!(@view(f_prev[n+2]), comm; source=right_rank)
            MPI.Send(@view(f_prev[2]), comm; dest=left_rank)
        end

        # stencil computation
        for i in 2:n+1 # for each regular cell
            diffusion_stencil!(f, f_prev, c, i)
        end

        f, f_prev = f_prev, f
        
        if rank == 0 && (step % 500_000 == 0)
            println("Step ", step)
        end
    end
    return f_prev
end

function main()
    MPI.Init()
    rank = MPI.Comm_rank(MPI.COMM_WORLD)

    MPI.Barrier(MPI.COMM_WORLD)
    t = -MPI.Wtime()
    f_loc = diffusion_1d()
    MPI.Barrier(MPI.COMM_WORLD)
    t += MPI.Wtime()

    f_sum = MPI.Reduce(f_loc, +, MPI.COMM_WORLD)
    if rank == 0
        println("total time: ", round(t; sigdigits=3), " sec")
        println("checksum: ", sum(f_sum))
    end

    MPI.Finalize()
end

main()
