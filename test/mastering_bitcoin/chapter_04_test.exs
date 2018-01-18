defmodule Chapter04Test do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  describe "MasteringBitcoin.EllipticCurvePointCheck.run()" do
    setup do
      result = MasteringBitcoin.EllipticCurvePointCheck.run()
      {:ok, [result: result, expected: 0]}
    end

    test "Example 4-1", %{result: result, expected: expected} do
      assert result == expected
    end
  end

  @tag lang: :cpp
  describe "MasteringBitcoin.Addr.run()" do
    setup do
      result = capture_io(fn -> MasteringBitcoin.Addr.run() end)
      expected =
        """
        Public key: \
        "0202a406624211f2abbdc68da3df929f938c3399dd79fac1b51b0e4ad1d26a47aa"
        Address: "1PRTTaJesdNovgne6Ehcdu1fpEdX7913CK"
        """
      {:ok, [result: result, expected: expected]}
    end

    test "Example 4-3", %{result: result, expected: expected} do
      assert result == expected
    end
  end

  describe "Non-idempotent tests that output to stdout" do
    setup %{mod: module} do
      result = capture_io(fn -> module.run() end)
      {:ok, [result: result]}
    end

    @tag mod: MasteringBitcoin.KeyToAddressECCExample, lang: :py
    test "Example 4-5", %{result: result} do
      assert result
    end

    @tag mod: MasteringBitcoin.ECMath, lang: :py
    test "Example 4-7", %{result: result} do
      assert result
    end

    @tag mod: MasteringBitcoin.VanityMiner, lang: :cpp
    test "Example 4-9", %{result: result} do
      assert result
    end
  end
end
