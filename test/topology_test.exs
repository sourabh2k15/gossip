ExUnit.start

defmodule TopologyTest do
    use ExUnit.Case

    Code.require_file "../lib/project2.ex"
    Code.require_file "../lib/topology.ex"

    test "builds 2d Grid" do
        nodes = Topology.build("2D", 10)
        
        assert length(nodes) > 0    
    end
end