defmodule Util do
  # Utility functions 

  # picks a random node from a given list
  def pickRandom(nodesList) do
    :random.seed(:erlang.system_time())
    Enum.random(nodesList) 
  end
  
end