# P2P: Ring communication (among workers)
using Distributed

function main()
    nw = nworkers()
    ws = workers()
    println(join(workers(), " --> "), "\n")

    # each worker gets a channel (with remote ref)
    rcs = Dict(ws .=> [RemoteChannel(() -> Channel{Int}(1), pid) for pid in ws])

    tasks = map(1:nw) do i
        right = ws[mod1(i + 1, nw)]
        @spawnat ws[i] begin
            println("Sending to worker ", right)
            t_put = @async put!(rcs[right], myid())
            t_take = @async take!(rcs[myid()])
            wait(t_put)
            val = fetch(t_take)
            println("Received ", val)
        end
    end
    wait.(tasks)
    return nothing
end

main()
