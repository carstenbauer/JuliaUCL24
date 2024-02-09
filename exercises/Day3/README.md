# Exercises - Day 3

## Multithreading

### `1_montecarlo_pi_multithreading`

In this exercise, you will parallelize a simple Monte Carlo algorithm that can produce the value of π=3.141... with desirable precision. Specifically, you will parallelize the algorithm using multithreading (`@threads` and `@spawn`).

### `2_juliaset`

Here, we will compute an image of the [Julia set](https://en.wikipedia.org/wiki/Julia_set) using a sequential and and two multithreaded variants (`@threads` and `@spawn`). In particular, you will see the benefit of load balancing for certain workloads.

### `3_daxpy_cpu`

You'll consider a multithreaded DAXPY kernel. You'll explore the basic topology of a Noctua 2 compute node and will study how thread affinity and memory initialization can influence the performance dramatically (keyword: NUMA). You'll estimate the scaling of the maximal memory bandwidth on a Noctua 2 node as a function of the number of Julia threads.

## GPU

### `4_saxpy_gpu`

You'll try to measure the maximal, obtainable memory bandwidth of an NVIDIA A100 GPU. To that end, you'll consider different realizations of a SAXPY kernel running on the GPU. Specifically, you'll move the SAXPY computation to the GPU via array abstractions and will then hand-write a custom CUDA kernel. Afterwards, you'll compare your variants to a built-in CUBLAS implementation by NVIDIA.

### `5_juliaset_gpu`

In this exercise, we will revisit the problem of computing an image of the Julia Set. But this time we will compare a sequential CPU variant to a parallel GPU implementation (using a custom CUDA kernel).

### `6_heat_diffusion`

We'll consider the heat equation, a partial differential equation (PDE) describing the diffusion of heat over time, in two spatial dimensions. You will implement an explicit, iterative stencil solver for the equation and will learn how to move this solver from the CPU to the GPU by either using array abstractions or explicit CUDA kernels. Finally, you'll compare the performance of the different variants.

