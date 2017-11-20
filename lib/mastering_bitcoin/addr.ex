defmodule MasteringBitcoin.Addr do
  @moduledoc """
  Example 4-3. Creating a Base58Check-encoded bitcoin address from a
  private key.

  NOTE: There isn't an Elixir library that wraps the C++ libbitcoin library,
  and I can't figure out how to get Elixir to talk directly to libbitcoin.
  So, instead, the Porcelain library is used to compile and run the original
  C++ file directly, and then simply output the result in Elixir.
  """

  @src_compile """
  g++ -std=c++11 -o src/addr src/addr.cpp \
  $(pkg-config --cflags --libs libbitcoin)
  """
  @src_execute "./src/addr"

  def run do
    Porcelain.shell(@src_compile)

    @src_execute
    |> Porcelain.shell()
    |> Map.fetch!(:out)
    |> IO.write()
  end
end
