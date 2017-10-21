defmodule MasteringBitcoin.RPCBlock do
  @moduledoc """
  rpc_block.py example
  """

  alias MasteringBitcoin.Client, as: RawProxy

  def run do
    # The block height where Alice's transaction was recorded.
    "277316"
    # Get the block hash of block with height 277316
    |> get_blockhash()
    |> get_transactions()
    |> calculate_block_value()
    |> (fn(block_value) -> "(Total value in block: #{block_value})" end).()
    |> IO.puts()
  end

  defp get_blockhash(blockheight) do
    case RawProxy.getblockhash(blockheight) do
      {:ok, blockhash} ->
        blockhash
      {:error, _reason} ->
        get_blockhash_from_latest_block()
    end
  end

  # NOTE: If you are querying a full node on your local machine that doesn't
  # have the entire blockchain on it, then you may not have the block where
  # Alice's transaction was recorded. In that case, grab the latest block
  # available in your local node.
  defp get_blockhash_from_latest_block do
    with {:ok, blockheight} <- RawProxy.getblockcount,
         {:ok, blockhash} <- RawProxy.getblockhash(blockheight) do
      blockhash
    else
      {:error, reason} ->
        reason
        |> Map.get("reason")
        |> (fn(reason) -> "Couldn't get a blockhash: #{reason}" end).()
        |> raise
    end
  end

  defp get_transactions(blockhash) do
    # Retrieve the block by its hash
    with {:ok, block} <- RawProxy.getblock(blockhash),
         # Element tx contains the list of all transaction IDs in the block
         {:ok, transactions} <- Map.fetch(block, "tx") do
      transactions
    else
      {:error, reason} ->
        reason
        |> Map.get("message")
        |> (fn(reason) -> "Couldn't get transactions: #{reason}" end).()
        |> raise
    end
  end

  defp calculate_block_value(transactions) do
    transactions
    # Iterate through each transaction ID in the block
    |> Enum.reduce(0, fn(txid, block_value) ->
         # Retrieve the raw transaction by ID
         with {:ok, raw_tx} <- RawProxy.getrawtransaction(txid),
              # Decode the transaction
              {:ok, decoded_tx} <- RawProxy.decoderawtransaction(raw_tx) do
           # Iterate through each output in the transaction
           decoded_tx
           |> Map.get("vout")
           |> Enum.reduce(0, fn(output, tx_value) ->
                # Add up the value of each output
                output
                |> Map.get("value")
                |> Kernel.+(tx_value)
              end)
           |> Kernel.+(block_value)
         else
           {:error, reason} ->
             reason
             |> Map.get("message")
             |> (fn(reason) -> "Couldn't decode transaction: #{reason}" end).()
             |> raise
         end
       end)
  end
end
