defmodule MasteringBitcoin do
  @moduledoc """
  Documentation for MasteringBitcoin.
  """

  require Integer

  # NOTE: Elixir doesn't have an exponent function, and `:math.pow` in Erlang's
  # library doesn't play nice with large integer exponent values, so use a
  # custom function instead.
  # REF: https://stackoverflow.com/a/32030190
  def pow(_n, 0), do: 1
  def pow(n, exp) when Integer.is_odd(exp), do: n * pow(n, exp - 1)

  def pow(n, exp) do
    result = pow(n, div(exp, 2))
    result * result
  end
end
