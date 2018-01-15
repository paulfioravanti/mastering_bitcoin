defmodule MasteringBitcoin.Addr do
  @moduledoc """
  Example 4-3. Creating a Base58Check-encoded bitcoin address from a
  private key.

  Port over of some code contained in the `addr.cpp` file.
  """

  alias Bitcoin.Key.Public, as: PublicKey
  alias MasteringBitcoin.Secp256k1

  # Private secret key string as base16
  @private_key """
  038109007313a5807b2eccc082c8c3fbb988a973cacf1a7df9ce725c31b14776\
  """

  def run do
    with bitcoin_public_key <- Secp256k1.bitcoin_public_key(@private_key),
         bitcoin_address <- create_bitcoin_address(bitcoin_public_key) do
      IO.puts("Public key: #{inspect(bitcoin_public_key)}")
      IO.puts("Address: #{inspect(bitcoin_address)}")
    end
  end

  defp create_bitcoin_address(public_key) do
    public_key
    |> Base.decode16!(case: :lower)
    |> PublicKey.to_address()
  end
end
