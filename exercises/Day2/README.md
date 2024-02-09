# Exercises - Day 2

## Performance optimization (single-core)

### `1_perf_optimization`

Given examplatory code snippets, your task will be to optimize them (as much as you can/want to) by utilizing parts of what you've learned in the morning.

### `2_SIMD_datadep`

In this exercise, you'll be given a for loop with a data dependency that isn't readily vectorizable. You'll learn how you can rewrite the loop to facilitate SIMD and improve the performance.

### `3_cache_bandwidths`

By means of a Schoenauer triad kernel, you'll try to measure the effect of the memory hierarchy (i.e. caches) on performance for a CPU-core in a Noctua 2 compute node.

### `4_dense_matmul`

Here, we'll consider a seemingly simple computation: (dense) matrix-matrix multiplication. You will see that different implementations (e.g. naive vs cache blocking) have vastly different performance.

### `5_likwid`

In this exercise you will reproduce the "counting flops" demonstration from the kickoff presentation. We will use Jupyter instead of Pluto though.

