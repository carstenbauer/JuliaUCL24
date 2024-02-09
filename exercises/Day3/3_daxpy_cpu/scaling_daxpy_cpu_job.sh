#!/bin/bash
#SBATCH --account=hpc-lco-usrtr
#SBATCH --job-name=scaling_daxpy_cpu
#SBATCH --partition=normal
#SBATCH --time=00:20:00
#SBATCH -N 1
#SBATCH --exclusive
#SBATCH --output=scaling_daxpy_cpu_job-%A.out

# load necessary modules
ml r
ml lang/JuliaHPC/1.10.0-foss-2022a-CUDA-11.7.0 

export JULIA_DEPOT_PATH=:/scratch/hpc-lco-usrtr/.julia_ucl

# run program
julia --project -t 128 scaling_daxpy_cpu.jl
