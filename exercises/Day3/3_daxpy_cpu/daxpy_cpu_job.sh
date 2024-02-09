#!/bin/bash
#SBATCH --account=hpc-lco-usrtr
#SBATCH --job-name=daxpy_cpu
#SBATCH --partition=normal
#SBATCH --time=00:10:00
#SBATCH -N 1
#SBATCH --exclusive
#SBATCH --output=daxpy_cpu_job-%A.out

# load necessary modules
ml r
ml lang/JuliaHPC/1.10.0-foss-2022a-CUDA-11.7.0 

export JULIA_DEPOT_PATH=:/scratch/hpc-lco-usrtr/.julia_ucl

# run program
julia --project -t 8 daxpy_cpu.jl
