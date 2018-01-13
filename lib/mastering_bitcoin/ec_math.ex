defmodule MasteringBitcoin.ECMath do
  @moduledoc """
  Example 4-7. A script demonstrating elliptic curve math used for bitcoin keys.

  Port over of most code contained in the `ec_math.py` file.
  """

  # secp256k1, http://www.oid-info.com/get/1.3.132.0.10
  @p 0xffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_fffffffe_fffffc2f
  @r 0xffffffff_ffffffff_ffffffff_fffffffe_baaedce6_af48a03b_bfd25e8c_d0364141
  @b 0x00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000007
  @a 0x00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000
  @gx 0x79be667e_f9dcbbac_55a06295_ce870b07_029bfcdb_2dce28d9_59f2815b_16f81798
  @gy 0x483ada77_26a3c465_5da4fbfc_0e1108a8_fd17b448_a6855419_9c47d08f_fb10d4b8

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
