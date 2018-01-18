defmodule Chapter03Test do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  @moduletag :bitcoin_server

  setup_all do
    Porcelain.shell("brew services start bitcoin")
    # The following time is arbitrary, but seems to be enough time
    # for the server to be spun up and for wallets to be inspected and
    # the blockchain checked.
    Process.sleep(15000)

    on_exit(fn -> Porcelain.shell("brew services stop bitcoin") end)
  end

  setup %{mod: module} do
    result = capture_io(fn -> module.run() end)
    {:ok, [result: result]}
  end

  @tag mod: MasteringBitcoin.RPCExample
  test "Example 3-3", %{result: result} do
    assert result
  end

  @tag mod: MasteringBitcoin.RPCTransaction
  test "Example 3-4", %{result: result} do
    assert result
  end

  @tag mod: MasteringBitcoin.RPCBlock
  test "Example 3-5", %{result: result} do
    assert result
  end
end
