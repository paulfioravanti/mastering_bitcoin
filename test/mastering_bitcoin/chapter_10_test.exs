defmodule Chapter10Test do
  use ExUnit.Case
  import ExUnit.CaptureIO

  setup(%{module: module}) do
    result = capture_io(fn -> module.run() end)
    {:ok, [result: result]}
  end

  @tag module: MasteringBitcoin.MaxMoney
  describe "MasteringBitcoin.MaxMoney.run()" do
    setup do
      expected = "Total BTC to ever be created: 2099999997690000 Satoshis\n"
      {:ok, [expected: expected]}
    end

    test "Example 10-1", %{result: result, expected: expected} do
      assert result == expected
    end
  end

  @tag module: MasteringBitcoin.SatoshiWords, lang: :cpp
  describe "MasteringBitcoin.SatoshiWords.run()" do
    setup do
      expected =
        """
        The Times 03/Jan/2009 Chancellor on brink of second bailout for banks
        """
      {:ok, [expected: expected]}
    end

    test "Example 10-6", %{result: result, expected: expected} do
      assert result == expected
    end
  end
end
