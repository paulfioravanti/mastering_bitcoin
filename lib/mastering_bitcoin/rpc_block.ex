defmodule MasteringBitcoin.RPCBlock do
  @moduledoc """
  rpc_block.py example
  """

  alias MasteringBitcoin.Client, as: RawProxy

  def run do
    block_value =
      # The block height where Alice's transaction was recorded.
      277316
      |> get_blockhash()
      |> get_transactions()
      |> calculate_block_value()
    IO.puts "(Total value in block: #{block_value})"
  end

  defp get_blockhash(blockheight) do
    # Get the block hash of block with height 277316
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
        IO.puts "Couldn't get a blockhash"
        raise reason
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
        IO.puts "Couldn't get transactions"
        raise reason
    end
  end

  defp calculate_block_value(transactions) do
    # Iterate through each transaction ID in the block
    Enum.reduce(transactions, 0, fn(txid, block_value) ->
      # Add the value of this transaction to the total
      sum_transaction_values(txid) + block_value
    end)
  end

  defp sum_transaction_values(txid) do
    # Retrieve the raw transaction by ID
    with {:ok, raw_tx} <- RawProxy.getrawtransaction(txid),
         # Decode the transaction
         {:ok, decoded_tx} <- RawProxy.decoderawtransaction(raw_tx) do
      decoded_tx
      |> Map.get("vout")
      # Iterate through each output in the transaction
      |> Stream.map(&(Map.get(&1, "value")))
      # Add up the value of each output
      |> Enum.sum()
    else
      {:error, reason} ->
        IO.puts "Couldn't decode transaction"
        raise reason
    end
  end
end
