defmodule MasteringBitcoin.RPCTransaction do
  @moduledoc """
  rpc_transaction.py example
  """

  alias MasteringBitcoin.Client, as: RawProxy

  def run do
    # Alice's transaction ID
    "0627052b6f28912f2703066a912ea577f2ce4da4caa5a5fbd8a57286c345c2f2"
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
