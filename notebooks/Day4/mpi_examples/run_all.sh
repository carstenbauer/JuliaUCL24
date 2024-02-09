for f in *.jl
do
    echo "Running $f"
    mpiexecjl --project -n 5 julia "$f"
done
