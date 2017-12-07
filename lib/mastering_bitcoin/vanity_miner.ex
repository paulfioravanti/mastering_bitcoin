defmodule MasteringBitcoin.VanityMiner do
  @moduledoc """
  Example 4-9. Vanity address miner

  Currently a non-port over of the `vanity-miner.cpp` file.

  NOTE: There isn't an Elixir library that wraps the C++ libbitcoin library,
  and I can't figure out how to get Elixir to talk directly to libbitcoin.
  So, instead, the Porcelain library is used to compile and run the original
  C++ file directly, and then simply output the result in Elixir.
  """

  @src_compile """
  g++ -std=c++11 -o priv/vanity-miner priv/vanity-miner.cpp \
  $(pkg-config --cflags --libs libbitcoin)
  """
  @src_execute "./priv/vanity-miner"

  def run do
    Porcelain.shell(@src_compile)

    @src_execute
    |> Porcelain.shell()
    |> Map.fetch!(:out)
    |> IO.write()
  end
end
