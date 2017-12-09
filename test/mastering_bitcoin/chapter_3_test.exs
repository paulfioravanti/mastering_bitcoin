defmodule Chapter3Test do
  use ExUnit.Case

  @moduletag :bitcoin_server

  setup_all do
    Porcelain.shell("brew services start bitcoin")
    Process.sleep(10000)

    on_exit(fn -> Porcelain.shell("brew services stop bitcoin") end)
  end

  test "Example 3-3" do
    MasteringBitcoin.RPCExample.run()
  end

  test "Example 3-4" do
    MasteringBitcoin.RPCTransaction.run()
  end

  test "Example 3-5" do
    MasteringBitcoin.RPCBlock.run()
  end

end
