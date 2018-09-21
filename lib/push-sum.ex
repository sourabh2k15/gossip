defmodule Pushsum do
    @accuracy 0.000000001

    def start(nodes, start_time) do
        #initialization
        Enum.each(0..length(nodes)-1, fn x ->
            send(Enum.at(nodes, x), {:start, x+1, 1}) 
        end)

        listen(length(nodes), 0, start_time)
    end

    def listen(n, converged, start_time) do 
        receive do
            {:converged, ratio} ->
                converged = converged + 1

                if converged >= 0.9*(n-1) do
                    end_time = :erlang.system_time / 1.0e6 |> round
                    IO.puts "System converged with ratio #{ratio} in #{(end_time - start_time)}"
                    
                    System.halt(0)
                else    
                    IO.puts "#{converged}/#{n} nodes converged, latest ratio: #{ratio}"                    
                    listen(n, converged, start_time)                   
                end
        end
    end

    def pushsumNode(s, w, delta1, delta2, isConverged, neighbours\\[]) do
        receive do
            {:initialize_neighbours, neighbourlist} ->
                neighbours = neighbours ++ neighbourlist
                pushsumNode(0, 0, -1, -1, isConverged, neighbours)

            {:receive, s_i, w_i} ->
                s = s + s_i
                w = w + w_i
                pushsumNode(s, w, delta1, delta2, isConverged, neighbours)

            {:start, s_0, w_0} ->
                send(self(), {:receive, s_0, w_0})
                pushsumNode(0, 0, -1, -1, isConverged, neighbours)          
        after    
            0_010 ->
                #present values of s and w, calculate delta1 and delta2 here and send converged messages
                
                w = if w == 0 do 0.1 else w end
                ratio = s/w
                #IO.puts "#{delta1} , #{delta2}, #{ratio}"
                if !isConverged do
                    {delta1, delta2} = updateDeltas(delta1, delta2, ratio)

                    isConverged = if delta1 == 2 and delta2 == 2 do true else false end

                    nid = Util.pickRandom(neighbours)
                    send(nid, {:receive, s/2, w/2})
                    send(self(), {:receive, s/2, w/2})
                    pushsumNode(0, 0, delta1, delta2, isConverged, neighbours)    
                else
                    head = :global.whereis_name("head")
                    send(head, {:converged, ratio})
                    
                    receive do
                        {_} -> "waiting forever to be killed" 
                    end
                end                      
        end
    end

    def updateDeltas(delta1, delta2, ratio) do
    
        if delta1 == -1 do
            {ratio, -1}
        else
            if delta2 == -1 do
                diff = delta1 - ratio |> abs
        
                if diff > 0 and diff < @accuracy do
                    {delta1, ratio} 
                else
                    {ratio, -1}
                end
            else
                diff = delta2 - ratio |> abs
            
                if diff > 0 and diff < @accuracy do
                    #IO.puts "#{delta1} , #{delta2}, #{ratio}"
                    {2, 2}
                else
                    {ratio, -1}
                end
            end
        end
    
    end

end