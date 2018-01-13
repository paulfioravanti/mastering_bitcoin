defmodule MasteringBitcoin.ECMath do
  @moduledoc """
  Example 4-7. A script demonstrating elliptic curve math used for bitcoin keys.

  Port over of most code contained in the `ec_math.py` file.
  """

  # secp256k1, http://www.oid-info.com/get/1.3.132.0.10
  @p 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_FFFFFC2F
  @r 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_BAAEDCE6_AF48A03B_BFD25E8C_D0364141
  @b 0x00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000007
  @a 0x00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000
  @gx 0x79BE667E_F9DCBBAC_55A06295_CE870B07_029BFCDB_2DCE28D9_59F2815B_16F81798
  @gy 0x483ADA77_26A3C465_5DA4FBFC_0E1108A8_FD17B448_A6855419_9C47D08F_FB10D4B8

  @python_src \
    :mastering_bitcoin
    |> :code.priv_dir()
    |> Path.basename()
  @python_file "ec-math"
  @num_secret_bytes 32
  @hex 16
  @greater_than_curve_midpoint "03"
  @less_than_curve_midpoint "02"

  use Bitwise
  use Export.Python

  def run do
    with {:ok, pid} <- Python.start(python_path: @python_src),
         secret <- random_secret(),
         public_key_ec_point <- public_key_elliptic_curve_point(pid, secret),
         public_key <- public_key_from_ec_point(public_key_ec_point) do
      IO.puts("Secret: #{inspect(secret)}")
      IO.puts("EC point: #{inspect(public_key_ec_point)}")
      IO.puts("BTC public key: #{inspect(public_key)}")
      Python.stop(pid)
    end
  end

  # Generate a new private key by collecting 256 bits of random data from
  # the OS's cryptographically secure random generator
  defp random_secret do
    @num_secret_bytes
    |> :crypto.strong_rand_bytes()
    |> Base.encode16()
    |> String.to_integer(@hex)
  end

  # Get the public key point.
  defp public_key_elliptic_curve_point(pid, secret) do
    Python.call(
      pid,
      @python_file,
      "public_key_elliptic_curve_point",
      [@p, @a, @b, @gx, @gy, @r, secret]
    )
  end

  defp public_key_from_ec_point({x, y}) do
    public_key_prefix(y) <> encoded_public_key(x)
  end

  defp public_key_prefix(y) when (y &&& 1) == 1 do
    @greater_than_curve_midpoint
  end
  defp public_key_prefix(_y), do: @less_than_curve_midpoint

  def encoded_public_key(x) do
    x
    |> :binary.encode_unsigned()
    |> Base.encode16(case: :lower)
  end
end
