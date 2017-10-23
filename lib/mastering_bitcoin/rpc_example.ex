defmodule MasteringBitcoin.RPCExample do
  @moduledoc """
  rpc_example.py example
  """

  alias MasteringBitcoin.Client, as: RawProxy

  def run do
    # Run the getinfo command, store the resulting data in info
    # NOTE: getinfo, as used in the book, has been deprecated and will be
    # removed from future versions of Bitcoin Core.
    # It looks like getmininginfo and is the API needed to get the current
    # number of blocks in a node, so use that.
    case RawProxy.getmininginfo do
      {:ok, info} ->
        info
        # Retrieve the 'blocks' element from the info
        |> Map.get("blocks")
        |> IO.puts()
      {:error, error} ->
        IO.puts(error)
    end
  end
end
