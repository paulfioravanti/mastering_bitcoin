defmodule MasteringBitcoin.EllipticCurvePointCheck do
  @moduledoc """
  Example 4-1. Using Python to confirm that this point is on the elliptic curve.

  Port over of the commands run in the Python console.
  """

  require Integer

  def run do
    p = 115792089237316195423570985008687907853269984665640564039457584007908834671663
    x = 55066263022277343669578718895168534326250603453777594175500187360389116729240
    y = 32670510020758816978083085130507043184471273380659243275938904335757337482424
    pow(x, 3) + 7 - pow(y, 2)
    |> Integer.mod(p)
  end

  # NOTE: Elixir doesn't have an exponent function, and `:math.pow` in Erlang's
  # library doesn't play nice with large integer exponent values, so use a
  # custom function instead.
  # REF: https://stackoverflow.com/a/32030190
  defp pow(_n, 0), do: 1
  defp pow(n, exp) when Integer.is_odd(exp), do: n * pow(n, exp - 1)
  defp pow(n, exp) do
    result = pow(n, div(exp, 2))
    result * result
  end
end
