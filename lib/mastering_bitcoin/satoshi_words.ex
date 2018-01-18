defmodule MasteringBitcoin.SatoshiWords do
  @moduledoc """
  Example 10-6. Extract the coinbase data from the genesis block.

  Port over of `satoshi-words.cpp` file.
  """

  alias Cure.Server, as: Cure

  @cpp_executable "priv/satoshi-words"

  def run do
    with {:ok, pid} <- Cure.start_link(@cpp_executable),
         words <- satoshi_words(pid) do
      IO.puts(words)
      :ok = Cure.stop(pid)
    end
  end

  def satoshi_words(pid) do
    Cure.send_data(pid, "Satoshi", :once)

    receive do
      {:cure_data, response} ->
        response
    end
  end
end
