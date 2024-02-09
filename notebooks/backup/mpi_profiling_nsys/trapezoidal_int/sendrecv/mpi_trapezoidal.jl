using MPI
using Printf

using NVTX
using Colors

function get_arguments(rank, com_size)
    if rank == 0
        a = parse(Float64, get(ARGS, 1, "0.0"))
        b = parse(Float64, get(ARGS, 2, "1.0"))
        n = parse(Int, get(ARGS, 3, "100000"))

        for dest in 1:com_size-1
            MPI.Send(a, dest, 0, MPI.COMM_WORLD)
            MPI.Send(b, dest, 0, MPI.COMM_WORLD)
            MPI.Send(n, dest, 0, MPI.COMM_WORLD)
        end
    else
        a, = MPI.Recv(Float64, 0, 0, MPI.COMM_WORLD)
        b, = MPI.Recv(Float64, 0, 0, MPI.COMM_WORLD)
        n, = MPI.Recv(Int, 0, 0, MPI.COMM_WORLD)
    end
    return a, b, n
end

f(x) = x * x

F(x) = x^3 / 3

function integrate(left, right, count, len)
    estimate = (f(left) + f(right)) / 2.0
    for i in 1:count-1
        x = left + i * len
        estimate += f(x)
    end
    return estimate * len
end


function main()
    MPI.Init()
    NVTX.enable_gc_hooks()

    rank = MPI.Comm_rank(MPI.COMM_WORLD)
    com_size = MPI.Comm_size(MPI.COMM_WORLD)

    nvtx_range = NVTX.range_start(; message="integration", color=colorant"yellow")
    NVTX.range_push(; message="get_arguments", color=colorant"blue")
    a, b, n = get_arguments(rank, com_size)
    NVTX.range_pop()

    NVTX.range_push(; message="local integration", color=colorant"red")
    # h and local_n are the same for all processes
    h = (b - a) / n
    local_n = n / com_size

    # compute integration boundaries for each rank
    local_a = a + rank * local_n * h
    local_b = local_a + local_n * h

    # compute integral in bounds for each rank
    local_int = integrate(local_a, local_b, local_n, h)
    NVTX.range_pop()

    NVTX.range_push(; message="collect results", color=colorant"green")
    if rank != 0
        # Worker: send local result to master
        MPI.Send(local_int, 0, 0, MPI.COMM_WORLD)
    else
        # Master: add up results
        total_int = local_int
        for src in 1:com_size-1
            worker_int, = MPI.Recv(Float64, src, 0, MPI.COMM_WORLD)
            total_int += worker_int
        end
    end
    NVTX.range_pop()
    NVTX.range_end(nvtx_range)

    # Master: print result
    if rank == 0
        @printf("With n = %d trapezoids, our estimate of the integral from %f to %f is %.12e (exact: %f)\n", n, a, b, total_int, F(b) - F(a))
    end

    MPI.Finalize()
end

# run main function
main()
