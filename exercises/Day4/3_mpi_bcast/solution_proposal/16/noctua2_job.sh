#!/bin/bash
#SBATCH --account=pc2-mitarbeiter
#SBATCH --job-name=mpi_bcast
#SBATCH --partition=all
#SBATCH --time=00:05:00
#SBATCH -N 16
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=128
#SBATCH --exclusive
#SBATCH --output=mpi_bcast_job-%A.out

# load necessary modules
ml r
ml lang/JuliaHPC/1.10.0-foss-2022a-CUDA-11.7.0

# set environment variables
export JULIA_DEPOT_PATH=:/scratch/hpc-lco-usrtr/.julia_ucl
export SLURM_EXPORT_ENV=ALL

# run program
N=268435456
mpiexecjl --project -n 16 julia ../mpi_bcast_builtin.jl $N
mpiexecjl --project -n 16 julia ../mpi_bcast_tree.jl $N
mpiexecjl --project -n 16 julia ../mpi_bcast_sequential.jl $N
