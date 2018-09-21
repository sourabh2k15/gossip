defmodule Topology do
    def build(topology, n, algorithm) do
        nodes = generateActors(n, algorithm)
  
        case topology do
            "full" -> 
                Enum.each(nodes, fn x -> 
                    neighborlist = nodes -- [x]
                    send(x, {:initialize_neighbours, neighborlist})
                end)
            "2D" ->
                form2Dgrid("perfect", nodes)
            "line" -> 
                neighborlist = []

                Enum.each(0..n-1, fn x -> 
                    neighborlist = neighborlist ++ if x-1 >= 0 do [Enum.at(nodes, x-1)] else [Enum.at(nodes, x-1+length(nodes))] end
                    neighborlist = neighborlist ++ if x+1 < n do [Enum.at(nodes, x+1)] else [Enum.at(nodes, x+1-length(nodes))] end

                    send(Enum.at(nodes, x), {:initialize_neighbours, neighborlist})
                end)
            "imp2D" -> 
                form2Dgrid("imperfect", nodes)
        end    
       
        nodes
    end
    
    def generateActors(n, algorithm) do        
        Enum.map(1..n, fn _ ->
            case algorithm do
                "gossip" ->
                    spawn(fn -> Gossip.gossipNode(0, []) end)        
                "push-sum" ->
                    spawn(fn -> Pushsum.pushsumNode(0, 0, -1, -1, false, []) end)
            end 
        end)
    end

    def form2Dgrid(type, nodes) do
        n = length(nodes)
        dim = round(:math.ceil(:math.sqrt(n)))
        grid = Enum.chunk_every(nodes, dim)
        neighborlist = []
       
        Enum.each(0..dim*dim, fn x ->
            if x < n do 
                i = round(:math.floor(x/dim)); j = rem(x, dim);
                                                       
                left = if j-1 < 0 do j-1 + length(Enum.at(grid, i)) else j-1 end
                right = if j+1 >= length(Enum.at(grid, i)) do j+1 - length(Enum.at(grid, i)) else j+1 end
                top = if i-1 < 0 do i - 1 + length(grid) else i-1 end
                bottom = if i+1 >= length(grid) do i+1-length(grid)  else i+1 end
       
                neighborlist = _2DHelper([top, bottom, left, right], i, j, grid)
                neighborlist = neighborlist ++ if type == "imperfect" do [Util.pickRandom(nodes -- ([Enum.at(Enum.at(grid, i), j)] ++ neighborlist) )] else [] end

                send(Enum.at(Enum.at(grid, i), j), {:initialize_neighbours, neighborlist})
            end 
        end)
    end

    def _2DHelper([top, bottom, left, right], i, j, grid) do
        top    = Enum.at(Enum.at(grid, top), j)
        bottom = Enum.at(Enum.at(grid, bottom), j)
        left   = Enum.at(Enum.at(grid, i), left)
        right  = Enum.at(Enum.at(grid, i), right)

        #filtering out nil nodes
        Enum.reduce([top, bottom, left, right], [], fn(x, l) -> 
            if x == nil do l else [x | l] end
        end)
    end 
end