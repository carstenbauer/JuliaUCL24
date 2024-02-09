using MPI

function main()
    MPI.Init()

    comm = MPI.COMM_WORLD
    rank = MPI.Comm_rank(comm)
    nranks = MPI.Comm_size(comm)

    # ring topology, i.e. periodic boundary conditions
    left  = mod(rank - 1, nranks)
    right = mod(rank + 1, nranks)

    msg = rand(2^22)

    for r in 0:nranks-1
        MPI.Barrier(comm)
        if r == rank
            println("Rank $r will start Recv!/Send soon.")
        end
    end

    # non-blocking communication → no deadlock
    req1 = MPI.Irecv!(msg, comm; source=left)
    req2 = MPI.Isend(msg, comm; dest=right)
    
    # blocking wait
    MPI.Waitall([req1, req2])

    # the following will be reached
    for r in 0:nranks-1
        MPI.Barrier(comm)
        if r == rank
            println("Rank $r has finished Recv!/Send.")
        end
    end

    MPI.Finalize()
end

main()