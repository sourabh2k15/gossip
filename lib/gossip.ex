defmodule Gossip do
    def gossipNode(counter, neighbours) do
        receive do
            {:initialize_neighbours, neighbourlist} ->
                neighbours = neighbours ++ neighbourlist
                gossipNode(counter, neighbours)

            {:gossip_propagate, rumor} ->
                Process.sleep(5)

                if counter >= 10 do
                    gossipNode(counter, neighbours)
                else 
                    nid = Util.pickRandom(neighbours)
                    send(nid, {:gossip_propagate, rumor})

                    send(self(), {:gossip_start, rumor})
                    gossipNode(counter, neighbours)
                end

            {:gossip_start, rumor} ->
                if counter == 0 do
                    head = :global.whereis_name("head")
                    if head != :undefined do send(head, {:informed}) else Process.exit(self(), :kill) end
                end

                send(self(), {:gossip_propagate, rumor})
                gossipNode(counter+1, neighbours)
        end
    end

    def gossip(nodes, rumor, informed, start) do
        startnode = Util.pickRandom(nodes)
        send(startnode, {:gossip_start, rumor})

        listen(nodes, informed, start)
    end

    def listen(nodes, informed, start) do
        receive do
            {:informed} ->
                informed = informed + 1
                n = length(nodes) 
                a = (informed*100)/n |> :math.ceil |> round
                IO.puts "#{informed}/#{n} nodes have heard the rumor"
                
                if a < 90 do 
                    listen(nodes, informed, start)    
                else 
                    Enum.each(nodes, fn x ->
                        Process.exit(x, :kill)
                    end)

                    end_time = :erlang.system_time / 1.0e6 |> round
                    IO.puts "System converged in #{(end_time - start)} ms"
                end
        end 
    end
end
