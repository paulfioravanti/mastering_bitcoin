defmodule MasteringBitcoin.EllipticCurvePointCheck do
  @moduledoc """
  Example 4-1. Using Python to confirm that this point is on the elliptic curve.

  Port over of the commands run in the Python console.
  """

  import MasteringBitcoin, only: [pow: 2]

  @p """
     115792089237316195423570985008687907853\
     269984665640564039457584007908834671663\
     """
     |> String.to_integer()
  @x """
     55066263022277343669578718895168534326\
     250603453777594175500187360389116729240\
     """
     |> String.to_integer()
  @y """
     32670510020758816978083085130507043184\
     471273380659243275938904335757337482424\
     """
     |> String.to_integer()

  def run do
    @x
    |> (&(pow(&1, 3) + 7 - pow(@y, 2))).()
    |> Integer.mod(@p)
  end
end
