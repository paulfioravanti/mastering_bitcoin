defmodule MasteringBitcoin.ECMath do
  @moduledoc """
  Example 4-7. A script demonstrating elliptic curve math used for bitcoin keys.

  Port over of most code contained in the `ec_math.py` file.
  """

  @num_secret_bytes 32
  @hex 16
  @gt_curve_midpoint 0x03
  @lt_curve_midpoint 0x02

  use Bitwise

  def run do
    with secret <- random_secret(),
         {public_key, _secret} <- generate_secp256k1_public_key(secret),
         ec_point <- ec_point_from_secp256k1_public_key(public_key),
         bitcoin_public_key <- bitcoin_public_key_from_ec_point(ec_point) do
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

  defp generate_secp256k1_public_key(secret) do
    secret
    |> String.to_integer(@hex)
    |> (fn(int) -> :crypto.generate_key(:ecdh, :secp256k1, int) end).()
  end

  # Elliptic Curve point
  defp ec_point_from_secp256k1_public_key(public_key) do
    <<_prefix :: size(8), x :: size(256), y :: size(256)>> = public_key
    {x, y}
  end

  # Get the public key point.
  defp bitcoin_public_key_from_ec_point({x, y}) do
    <<public_key_prefix(y) :: size(8), x :: size(256)>>
    |> Base.encode16(case: :lower)
  end

  defp public_key_prefix(y) when (y &&& 1) == 1, do: @gt_curve_midpoint
  defp public_key_prefix(_y), do: @lt_curve_midpoint
end
