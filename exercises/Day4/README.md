# Exercises - Day 4

## Distributed

### `1_montecarlo_pi_distributed`

In these exercises, you will parallelize a simple Monte Carlo algorithm that can produce the value of π=3.141... with desirable precision. Specifically, you will parallelize the same algorithm using different parallelization techniques: multithreading (e.g. `@threads`/`@spawn`), and multiprocessing (Distributed.jl and MPI.jl).

### `2_mpi_diffusion_1d`

You will implement (parts of) a MPI-parallel solver for the one-dimensional diffusion equation. Specifically, you will use non-blocking MPI communication to overlap communication and computation.

### `3_mpi_bcast`

In this exercise, we will implement our own basic variants of `MPI.Bcast!` (broadcasting) using basic MPI primitives. Specifically, you'll write a "naive" version and a more efficient binary-tree based variant.