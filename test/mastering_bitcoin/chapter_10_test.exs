defmodule Chapter10Test do
  use ExUnit.Case
  import ExUnit.CaptureIO

  setup do
    result = capture_io(fn -> MasteringBitcoin.MaxMoney.run() end)
    expected = "Total BTC to ever be created: 2099999997690000 Satoshis\n"
    {:ok, [result: result, expected: expected]}
  end

  test "Example 10-1", %{result: result, expected: expected} do
    assert result == expected
  end
end
