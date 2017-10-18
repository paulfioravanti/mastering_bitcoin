defmodule MasteringBitcoin.RPCExample do
  @moduledoc """
  rpc_example.py example
  """

  alias MasteringBitcoin.Client

  def run do
    # Run the getinfo command, store the resulting data in info
    case Client.getinfo do
      {:ok, info} ->
        info
        # Retrieve the 'blocks' element from the info
        |> Map.get("blocks")
        |> IO.puts()
      {:error, error} ->
        IO.puts(error)
      error ->
        IO.puts(error)
    end
  end
end
