defmodule MasteringBitcoin.Merkle do
  @moduledoc """
  Example 9-1. Building a Merkle Tree

  Port over of some code contained in the `merkle.cpp` file.
  """

  alias Cure.Server, as: Cure

  @cpp_executable "priv/merkle"
  @hash_literal_1 """
  0000000000000000000000000000000000000000000000000000000000000000\
  """
  @hash_literal_2 """
  0000000000000000000000000000000000000000000000000000000000000011\
  """
  @hash_literal_3 """
  0000000000000000000000000000000000000000000000000000000000000022\
  """

  def run do
    with {:ok, pid} <- Cure.start_link(@cpp_executable),
         merkle_root <- merkle_root(pid) do
      IO.puts("Result: #{inspect(merkle_root)}")
      :ok = Cure.stop(pid)
    end
  end

  defp merkle_root(pid) do
    Cure.send_data(pid, @hash_literal_1, :once)
    Cure.send_data(pid, @hash_literal_2, :once)
    Cure.send_data(pid, @hash_literal_3, :once)

    receive do
      {:cure_data, response} ->
        response
        |> Base.encode16(case: :lower)
    end
  end
end
