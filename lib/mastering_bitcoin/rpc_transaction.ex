defmodule MasteringBitcoin.RPCTransaction do
  @moduledoc """
  rpc_transaction.py example
  """

  alias MasteringBitcoin.Client

  def run do
    # Alice's transaction ID
    "0627052b6f28912f2703066a912ea577f2ce4da4caa5a5fbd8a57286c345c2f2"
    # First, retrieve the raw transaction in hex
    |> get_or_generate_raw_transaction()
    # Decode the transaction hex into a JSON object
    |> Client.decoderawtransaction()
    |> decoded_transaction()
  end

  # NOTE: If you are querying a full node on your local machine that doesn't
  # have the entire blockchain on it, then you may not have Alice's txid,
  # so in that case, grab a transaction from the latest block that you have
  # in your node.
  defp get_or_generate_raw_transaction(txid) do
    case Client.getrawtransaction(txid) do
      {:ok, raw_tx} ->
        raw_tx
      {:error, _reason} ->
        with {:ok, block_count} <- Client.getblockcount,
             {:ok, header} <- Client.getblockhash(block_count),
             {:ok, block} <- Client.getblock(header),
             {:ok, tx} <- Map.fetch(block, "tx"),
             {:ok, txid} <- Enum.fetch(tx, 0),
             {:ok, raw_tx} <- Client.getrawtransaction(txid) do
          raw_tx
        else
          {:error, reason} ->
            raise "Couldn't generate a raw transaction: #{reason}"
        end
    end
  end

  defp decoded_transaction({:ok, decoded_tx}) do
    decoded_tx
    |> Map.get("vout")
    |> Enum.each(fn(output) ->
         "(#{output["scriptPubKey"]["addresses"]}, #{output["value"]})"
         |> IO.puts()
       end)
  end
  defp decoded_transaction(%{"error" => reason}), do: {:error, reason}
  defp decoded_transaction(error), do: error
end