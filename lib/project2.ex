defmodule Project2 do
  def main(args) do
    args |> parse_args
  end

  def parse_args(args) when length(args) != 3 do
    IO.puts "error : incorrect number of arguments passed!!"
  end

  def parse_args(args) when length(args) == 3 do
    [n, topology, algorithm] = args
    {n, _} = Integer.parse(n);

    nodes = Topology.build(topology, n, algorithm) # a list that contains pids of all processes started
    :global.register_name("head", self())
    
    start_time = :erlang.system_time / 1.0e6 |> round

    case algorithm do
      "gossip" -> Gossip.gossip(nodes, "gaby is getting married!", 1, start_time)
      "push-sum" -> Pushsum.start(nodes, start_time)
    end
  end

end
