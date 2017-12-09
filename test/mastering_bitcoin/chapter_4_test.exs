defmodule Chapter4Test do
  use ExUnit.Case
  import ExUnit.CaptureIO

  setup(%{module: module}) do
    result = capture_io(fn -> module.run() end)
    {:ok, [result: result]}
  end

  @tag module: MasteringBitcoin.EllipticCurvePointCheck
  test "Example 4-1", %{result: result} do
    assert result
  end

  @tag module: MasteringBitcoin.Addr, lang: :cpp
  test "Example 4-3", %{result: result} do
    assert result
  end

  @tag module: MasteringBitcoin.KeyToAddressECCExample, lang: :py
  test "Example 4-5", %{result: result} do
    assert result
  end

  @tag module: MasteringBitcoin.ECMath, lang: :py
  test "Example 4-7", %{result: result} do
    assert result
  end

  @tag module: MasteringBitcoin.VanityMiner, lang: :cpp
  test "Example 4-9", %{result: result} do
    assert result
  end
end
