defmodule MasteringBitcoin.ECMath do
  @moduledoc """
  Example 4-7. A script demonstrating elliptic curve math used for bitcoin keys.

  Port over of `ec_math.py` file.
  """

  # secp256k1, http://www.oid-info.com/get/1.3.132.0.10
  @p 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F
  @r 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141
  @b 0x0000000000000000000000000000000000000000000000000000000000000007
  @a 0x0000000000000000000000000000000000000000000000000000000000000000
  @gx 0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798
  @gy 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8

  @python_src "priv"
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
