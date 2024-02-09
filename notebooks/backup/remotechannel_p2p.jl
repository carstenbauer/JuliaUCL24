# P2P: All workers send to master
using Distributed

function main()
    rc = RemoteChannel(()->Channel{Int}(nworkers()), 1)

    for pid in workers()
        @spawnat pid put!(rc, myid())
    end
    
    # Alternatively:
    # @everywhere workers() put!($rc, myid())

    for _ in 1:nworkers()
        println("Received ", take!(rc))
    end
end

main()
