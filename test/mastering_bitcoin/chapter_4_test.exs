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

  @tag module: MasteringBitcoin.Addr
  test "Example 4-3", %{result: result} do
    assert result
  end

  @tag module: MasteringBitcoin.KeyToAddressECCExample
  test "Example 4-5", %{result: result} do
    assert result
  end

  @tag module: MasteringBitcoin.ECMath
  test "Example 4-7", %{result: result} do
    assert result
  end

  @tag module: MasteringBitcoin.VanityMiner
  test "Example 4-9", %{result: result} do
    assert result
  end
end
