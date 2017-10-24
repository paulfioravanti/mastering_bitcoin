defmodule MasteringBitcoin.Addr do
  @moduledoc """
  Example 4-3. Creating a Base58Check-encoded bitcoin address from a
  private key.

  NOTE: There isn't an Elixir library that wraps the C++ libbitcoin library,
  and I couldn't figure out how to get Elixir to talk directly to libbitcoin,
  and I couldn't seem to get the example addr.cpp file compiling in C++, so
  this stays skipped for now.
  """

  def run do
    # Private secret key.
    "038109007313a5807b2eccc082c8c3fbb988a973cacf1a7df9ce725c31b14776"
  end
end
