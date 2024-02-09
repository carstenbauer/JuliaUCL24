using MPI

MPI.Init()

comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
world_size = MPI.Comm_size(comm)

print("Hello world, I am rank $(rank) of $(world_size)\n")

MPI.Finalize()
