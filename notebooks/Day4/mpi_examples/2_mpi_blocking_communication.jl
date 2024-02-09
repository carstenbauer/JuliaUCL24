using MPI

MPI.Init()

comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
world_size = MPI.Comm_size(comm)

msg = fill(rank, 10)

if rank != 0
    # Worker: send the message `msg` to the master (rank 0) with the (irrelevant) tag `0`
    MPI.Send(msg, comm; dest=0) # blocking
else
    # Master: receive and print the messages one-by-one
    println(msg)
    for r in 1:world_size-1
        MPI.Recv!(msg, comm; source=r) # blocking
        println(msg)
    end
end

MPI.Finalize()
