defmodule MasteringBitcoin.MaxMoney do
  @moduledoc """
  Example 10-1. A script for calculating how much total Bitcoin will be issued.

  Port over of `max_money.py` file.
  """

  import MasteringBitcoin, only: [pow: 2]

  # Original block reward for miners was 50 BTC
  @start_block_reward 50
  # 210000 is around every 4 years with a 10 minute block interval
  @reward_interval 210_000
  # 50 BTC = 50 0000 0000 Satoshis
  @current_reward @start_block_reward * pow(10, 8)

  def run do
    IO.puts("Total BTC to ever be created: #{max_money()} Satoshis")
  end

  defp max_money(reward \\ @current_reward, total \\ 0)
  defp max_money(reward, total) when reward > 0 do
    total = total + @reward_interval * reward
    reward = div(reward, 2)
    max_money(reward, total)
  end
  defp max_money(_reward, total) do
    round(total)
  end
end
