using MPI

MPI.Init()

comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)

MPI.Barrier(comm);
t_start = MPI.Wtime();

@time sleep(rank)

MPI.Barrier(comm);
t_end = MPI.Wtime();
elapsed = t_end - t_start;

sleep(0.1*rank); println("Elapsed MPI Wtime: ", elapsed)

MPI.Finalize()
