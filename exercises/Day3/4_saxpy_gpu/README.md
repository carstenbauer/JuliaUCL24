# Exercise: SAXPY on NVIDIA GPU

In this exercise, you will implement two GPU-variants of the **SAXPY** kernel (`y[i] = a * x[i] + y[i]`, `Float32` "single" precision):

1) A version using array abstractions, i.e. `CuArrays` and simple broadcasting.
2) A hand-written SAXPY CUDA kernel.

Afterwards, you'll benchmark the performance of the variants and compare it to the CUBLAS implementation by NVIDIA (that ships with CUDA). Since SAXPY is memory bound, we'll consider the achieved memory bandwidth (GB/s) as the performance metric.
