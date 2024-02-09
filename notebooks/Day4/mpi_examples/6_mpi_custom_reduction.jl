using MPI
using StaticArrays
using Random

# custom type: must be isbitstype so we're using SVector here
struct MyType
    x::Float32
    y::Int64
    z::SVector{2,Int64}
end

# custom reducer function
myreducer(m1::MyType, m2::MyType) = MyType(m1.x + m2.x, m1.y + m2.y, m1.z .+ m2.z)

MPI.Init()

comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
world_size = MPI.Comm_size(comm)

data = [MyType(Float32(rank), rank, SVector{2,Int64}(rank,rank)) for _ in 1:10]
local_result = reduce(myreducer, data)

# Reduction: passing custom data and custom reducer function to MPI.Reduce
total_result = MPI.Reduce(local_result, myreducer, comm)

sleep(0.1*rank); @show local_result

MPI.Barrier(comm)
if rank == 0
    println("Total result: $total_result")
end

MPI.Finalize()
