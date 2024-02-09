#!/bin/bash
#SBATCH --account=pc2-mitarbeiter
#SBATCH --job-name=mpi_diffusion
#SBATCH --partition=all
#SBATCH --time=00:10:00
#SBATCH --nodes 2
#SBATCH --ntasks-per-node=5
#SBATCH --cpus-per-task=16
#SBATCH --exclusive
#SBATCH --output=mpi_diffusion_job-%A.out

# load necessary modules
ml r
ml lang/JuliaHPC/1.10.0-foss-2022a-CUDA-11.7.0

# set environment variables
export JULIA_DEPOT_PATH=:/scratch/hpc-lco-usrtr/.julia_ucl
export SLURM_EXPORT_ENV=ALL

# run program
echo -e "Blocking communication"
mpiexecjl --project -n 10 julia diffusion_1d.jl

echo -e "\n\nNon-blocking communication (overlapping with computation)"
mpiexecjl --project -n 10 julia diffusion_1d_hidecomm.jl
