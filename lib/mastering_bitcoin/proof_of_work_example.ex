defmodule MasteringBitcoin.ProofOfWorkExample do
  @moduledoc """
  Example 10-11. Simplified Proof-of-Work implementation

  Port over of some code contained in the `proof-of-work-example.py` file.
  """

  import MasteringBitcoin, only: [pow: 2]

  @starting_nonce 0
  # max nonce: 4 billion
  @max_nonce pow(2, 32)
  @test_block "test block with transactions"
  @nonce_increment 1

  # check if this is a valid result, below the target
  defguardp valid_nonce?(nonce) when nonce <= @max_nonce

  def run(difficulty \\ 0..32) do
    # difficulty from 0 to 31 bits
    Enum.reduce(difficulty, "", fn difficulty_bits, previous_block_hash ->
      difficulty = pow(2, difficulty_bits)

      IO.puts("Difficulty: #{difficulty} (#{difficulty_bits} bits)")
      IO.puts("Starting search...")

      # checkpoint the current time
      start_time = :os.system_time(:seconds)

      # make a new block which includes the hash from the previous block
      # we fake a block of transactions - just a string.
      # find a valid nonce for the new block
      {hash_result, nonce} =
        @test_block
        |> Kernel.<>(previous_block_hash)
        |> proof_of_work(difficulty_bits)

      start_time
      |> display_elapsed_time()
      |> display_hashing_power(nonce)

      IO.puts("")
      hash_result
    end)
  end

  defp proof_of_work(nonce \\ @starting_nonce, header, difficulty_bits)

  defp proof_of_work(nonce, header, difficulty_bits)
       when valid_nonce?(nonce) do
    target = pow(2, 256 - difficulty_bits)

    hash_result =
      :sha256
      |> :crypto.hash(to_string(header) <> to_string(nonce))
      |> Base.encode16(case: :lower)

    case String.to_integer(hash_result, 16) do
      result when result < target ->
        IO.puts("Success with nonce #{nonce}")
        IO.puts("Hash is #{hash_result}")
        {hash_result, nonce}

      _more_than_target ->
        proof_of_work(nonce + @nonce_increment, header, difficulty_bits)
    end
  end

  defp proof_of_work(nonce, _header, _difficulty_bits) do
    IO.puts("Failed after #{nonce} (max_nonce) tries")
    {nil, nonce}
  end

  defp display_elapsed_time(start_time) do
    # checkpoint how long it took to find a result
    elapsed_time =
      :seconds
      |> :os.system_time()
      |> Kernel.-(start_time)

    IO.puts("Elapsed Time: #{elapsed_time} seconds")
    elapsed_time
  end

  defp display_hashing_power(elapsed_time, nonce) when elapsed_time > 0 do
    # estimate the hashes per second
    nonce
    |> Kernel./(elapsed_time)
    |> :erlang.float_to_binary(decimals: 4)
    |> (&IO.puts("Hashing Power: #{&1} hashes per second")).()
  end

  defp display_hashing_power(_elapsed_time, _nonce), do: nil
end
