defmodule MasteringBitcoin.Secp256k1 do
  @moduledoc """
  Utility module to deal with functionality around secp265k1
  Elliptic Point Cryptography. Specifically,

  - Generating a secp256k1 public key from a private key
  - Extracting an Elliptic Curve point (EC Point) with coordinates {x, y}
    from a secp256k1 public key
  - Generating a Bitcoin public key from an EC Point
  """

  use Bitwise

  @hex 16
  @greater_than_curve_midpoint 0x03
  @less_than_curve_midpoint 0x02

  def bitcoin_public_key(private_key) do
    with {public_key, _private_key} <- public_key_from_private_key(private_key),
         ec_point <- ec_point_from_public_key(public_key),
         bitcoin_public_key <- bitcoin_public_key_from_ec_point(ec_point) do
      bitcoin_public_key
    end
  end

  def public_key_from_private_key(private_key) do
    private_key
    |> String.to_integer(@hex)
    |> (fn hex_num -> :crypto.generate_key(:ecdh, :secp256k1, hex_num) end).()
  end

  # Elliptic Curve point
  def ec_point_from_public_key(public_key) do
    <<_prefix::size(8), x::size(256), y::size(256)>> = public_key
    {x, y}
  end

  def bitcoin_public_key_from_ec_point({x, y}) do
    <<public_key_prefix(y)::size(8), x::size(256)>>
    |> Base.encode16(case: :lower)
  end

  defp public_key_prefix(y) when is_even?(y) do
    @greater_than_curve_midpoint
  end

  defp public_key_prefix(_y) do
    @less_than_curve_midpoint
  end

  defguardp is_even?(y) when (y &&& 1) == 1
end
