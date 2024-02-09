# Exercises: Sampling π with Monte Carlo

In these exercises you will **parallelize a simple Monte Carlo algorithm** that can produce the value of π=3.141... with desirable precision. Specifically, you will parallelize the algorithm using **multiprocessing** (via Distributed.jl and, separately, MPI.jl).

The Distributed.jl exercise is provided as a Jupyter notebook (`mc_distributed.ipynb`). The MPI exercise as a regular Julia script (`mc_mpi.jl`). Eventually you want to call the MPI script from the command line via `mpiexecjl --project -n 8 julia mc_mpi.jl`.
