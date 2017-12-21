defmodule Chapter9Test do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @expected """
  Result: "a34b0105b14f10225d7903d146f6cbc6e435e0ac6eafcd0b83d3ba84c08077d4"
  """

  @tag lang: :cpp
  describe "MasteringBitcoin.Merkle.run()" do
    setup do
      result = capture_io(fn -> MasteringBitcoin.Merkle.run() end)
      expected = @expected
      {:ok, [result: result, expected: expected]}
    end

    test "Example 9-2", %{result: result, expected: expected} do
      assert result == expected
    end
  end
end
