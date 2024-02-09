using MPI
using Random
using Printf

function main()
    if length(ARGS) >= 1
        N = parse(Int, ARGS[1])
    else
        N = 2^24 # default
    end
    
    MPI.Init()
    comm = MPI.COMM_WORLD
    nranks = MPI.Comm_size(comm)
    rank = MPI.Comm_rank(comm)
    # the number of ranks must
    # - greater than 1
    # - be integer power of 2
    @assert nranks > 1 && ispow2(nranks)
    
    Random.seed!(8)
    data = rand(N)                      # for verification, all ranks already hold the data that'll be broadcasted
    arr = (0 == rank) ? data : zeros(N) # actual array that we use for broadcast: data for the master, zeros for all other ranks
    MPI.Barrier(comm)
    start = MPI.Wtime()
    
    # Broadcast: sequential (naive)
    for rank_recv in 1:nranks-1
        if 0 == rank # non-blocking send
            MPI.Isend(arr, comm; dest=rank_recv)
        end
        if rank_recv == rank # blocking receive
            MPI.Recv!(arr, comm; source=0)
        end
    end
    
    MPI.Barrier(comm)
    stopp = MPI.Wtime()
    
    start_min = MPI.Reduce(start, MPI.MIN, comm) # the earliest start
    stopp_max = MPI.Reduce(stopp, MPI.MAX, comm) # the latest stop
    if 0 == rank
        walltime = stopp_max - start_min
        size_arr = sizeof(arr) * 1.0e-9
        size_msg = size_arr * 2.0 * (nranks - 1)
        @printf("Broadcast: sequential (naive)\n")
        @printf("number of ranks        = %8d\n", nranks)
        @printf("walltime               = %8.2f sec\n", walltime)
        @printf("size of the vector     = %8.2f GB\n", size_arr)
        @printf("send and recv messages = %8.2f GB\n", size_msg)
        @printf("bandwidth              = %8.2f GB/s\n\n", size_msg / walltime)
    end
    
    # verify correct results
    for i in 0:nranks-1
        MPI.Barrier(comm)
        if i == rank && !(data ≈ arr)
            println("VERIFICATION ERROR: rank ", rank, " didn't receive the correct result!")
        end
    end
    
    MPI.Finalize()
end

main()
