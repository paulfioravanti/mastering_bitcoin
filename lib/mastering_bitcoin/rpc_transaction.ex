defmodule MasteringBitcoin.RPCTransaction do
  @moduledoc """
  Example 3-4. Retrieving a transaction and iterating it's outputs.

  Port over of `rpc_transaction.py` file (with fallback capabilities when
  Alice's transaction ID isn't in the local blockchain).
  """

  alias MasteringBitcoin.Client, as: RawProxy

  @bitcoin_server_error """
  Bitcoin server still warming up. \
  run `brew services start bitcoin` for a while, then try again. \
  """

  def run do
    # Alice's transaction ID
    "0627052B6F28912F2703066A912EA577F2CE4DA4CAA5A5FBD8A57286C345C2F2"
    # First, retrieve the raw transaction in hex
    |> get_raw_transaction()
    # Decode the transaction hex into a JSON object
    |> RawProxy.decoderawtransaction()
    |> extract_values()
  end

  defp get_raw_transaction(txid) do
    case RawProxy.getrawtransaction(txid) do
      {:ok, raw_tx} ->
        raw_tx
      {:error, %{"code" => -28, "message" => message}} ->
        raise @bitcoin_server_error <> "Error message: #{message}"
      {:error, _reason} ->
        get_raw_transaction_from_latest_block()
    end
  end

  # NOTE: If you are querying a full node on your local machine that doesn't
  # have the entire blockchain on it, then you may not have Alice's txid,
  # so in that case, grab a transaction from the latest block that you have
  # in your node.
  defp get_raw_transaction_from_latest_block do
    with {:ok, blockheight} <- RawProxy.getblockcount,
         {:ok, blockhash} <- RawProxy.getblockhash(blockheight),
         {:ok, block} <- RawProxy.getblock(blockhash),
         {:ok, tx} <- Map.fetch(block, "tx"),
         {:ok, txid} <- Enum.fetch(tx, 0),
         {:ok, raw_tx} <- RawProxy.getrawtransaction(txid) do
      raw_tx
    else
      {:error, reason} ->
        raise "Couldn't get a raw transaction: #{reason}"
    end
  end

  defp extract_values({:ok, decoded_tx}) do
    decoded_tx
    |> Map.get("vout")
    |> Stream.map(&("(#{&1["scriptPubKey"]["addresses"]}, #{&1["value"]})"))
    |> Enum.each(&IO.puts/1)
  end
  defp extract_values(error), do: error
end
