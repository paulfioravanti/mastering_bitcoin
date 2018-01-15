defmodule MasteringBitcoin.ECMath do
  @moduledoc """
  Example 4-7. A script demonstrating elliptic curve math used for bitcoin keys.

  Port over of most code contained in the `ec_math.py` file.
  """

  alias MasteringBitcoin.Secp256k1

  @num_secret_bytes 32

  def run do
    with secret <- random_secret(),
         {public_key, _secret} <- Secp256k1.public_key_from_private_key(secret),
         ec_point <- Secp256k1.ec_point_from_public_key(public_key),
         bitcoin_public_key <-
           Secp256k1.bitcoin_public_key_from_ec_point(ec_point) do
      IO.puts("Secret: #{inspect(secret)}")
      IO.puts("EC point: #{inspect(ec_point)}")
      IO.puts("BTC public key: #{inspect(bitcoin_public_key)}")
    end
  end

  # Generate a new private key by collecting 256 bits of random data from
  # the OS's cryptographically secure random generator
  defp random_secret do
    @num_secret_bytes
    |> :crypto.strong_rand_bytes()
    |> Base.encode16()
  end
end
