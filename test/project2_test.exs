ExUnit.start

defmodule Project2Test do
  use ExUnit.Case
  Code.require_file "../lib/project2.ex"
  Code.require_file "../lib/topology.ex"
  Code.require_file "../lib/gossip.ex"
  Code.require_file "../lib/util.ex"
  
  test "gossip_full" do
    n = 1000
    Project2.main([Integer.to_string(n), "full", "gossip"])
  end
end
