export OPENBLAS_NUM_THREADS=1
nsys profile --stats=true --trace=nvtx,mpi --mpi-impl=mpich --force-overwrite=true mpiexecjl --project -np 6 julia -t 1 mpicode.jl  > nsys_profile.output 2>&1