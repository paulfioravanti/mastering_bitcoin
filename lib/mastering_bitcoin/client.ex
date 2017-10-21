defmodule MasteringBitcoin.Client do
  @moduledoc """
  Client module to interface with a Bitcoin full node.
  """

  @bitcoin_url Application.get_env(:mastering_bitcoin, :bitcoin_url)

  def decoderawtransaction(raw_tx) do
    bitcoin_rpc("decoderawtransaction", [raw_tx])
  end

  def getblock(header_hash) do
    bitcoin_rpc("getblock", [header_hash])
  end

  def getblockcount do
    bitcoin_rpc("getblockcount")
  end

  def getblockhash(block_height) do
    bitcoin_rpc("getblockhash", [block_height])
  end

  def getinfo do
    bitcoin_rpc("getinfo")
  end

  def getrawtransaction(txid) do
    bitcoin_rpc("getrawtransaction", [txid])
  end

  # Create a connection to local Bitcoin Core node
  defp bitcoin_rpc(method, params \\ []) do
    with url <- @bitcoin_url,
         command <- %{jsonrpc: "1.0", method: method, params: params},
         {:ok, body} <- Poison.encode(command),
         {:ok, response} <- HTTPoison.post(url, body),
         {:ok, metadata} <- Poison.decode(response.body),
         %{"error" => nil, "result" => result} <- metadata do
      {:ok, result}
    else
      %{"error" => reason} ->
        {:error, reason}
      error ->
        error
    end
  end
end
