defmodule Chapter10Test do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  describe "MasteringBitcoin.MaxMoney.run()" do
    setup do
      result = capture_io(fn -> MasteringBitcoin.MaxMoney.run() end)
      expected = "Total BTC to ever be created: 2099999997690000 Satoshis\n"
      {:ok, [result: result, expected: expected]}
    end

    test "Example 10-1", %{result: result, expected: expected} do
      assert result == expected
    end
  end

  @tag lang: :cpp
  describe "MasteringBitcoin.SatoshiWords.run()" do
    setup do
      result = capture_io(fn -> MasteringBitcoin.SatoshiWords.run() end)
      expected =
        """
        The Times 03/Jan/2009 Chancellor on brink of second bailout for banks
        """
      {:ok, [result: result, expected: expected]}
    end

    test "Example 10-6", %{result: result, expected: expected} do
      assert result == expected
    end
  end

  describe "MasteringBitcoin.HashExample.run()" do
    setup do
      result = capture_io(fn -> MasteringBitcoin.HashExample.run() end)
      expected =
        """
        I am Satoshi Nakamoto0 => \
        a80a81401765c8eddee25df36728d732acb6d135bcdee6c2f87a3784279cfaed
        I am Satoshi Nakamoto1 => \
        f7bc9a6304a4647bb41241a677b5345fe3cd30db882c8281cf24fbb7645b6240
        I am Satoshi Nakamoto2 => \
        ea758a8134b115298a1583ffb80ae62939a2d086273ef5a7b14fbfe7fb8a799e
        I am Satoshi Nakamoto3 => \
        bfa9779618ff072c903d773de30c99bd6e2fd70bb8f2cbb929400e0976a5c6f4
        I am Satoshi Nakamoto4 => \
        bce8564de9a83c18c31944a66bde992ff1a77513f888e91c185bd08ab9c831d5
        I am Satoshi Nakamoto5 => \
        eb362c3cf3479be0a97a20163589038e4dbead49f915e96e8f983f99efa3ef0a
        I am Satoshi Nakamoto6 => \
        4a2fd48e3be420d0d28e202360cfbaba410beddeebb8ec07a669cd8928a8ba0e
        I am Satoshi Nakamoto7 => \
        790b5a1349a5f2b909bf74d0d166b17a333c7fd80c0f0eeabf29c4564ada8351
        I am Satoshi Nakamoto8 => \
        702c45e5b15aa54b625d68dd947f1597b1fa571d00ac6c3dedfa499f425e7369
        I am Satoshi Nakamoto9 => \
        7007cf7dd40f5e933cd89fff5b791ff0614d9c6017fbe831d63d392583564f74
        I am Satoshi Nakamoto10 => \
        c2f38c81992f4614206a21537bd634af717896430ff1de6fc1ee44a949737705
        I am Satoshi Nakamoto11 => \
        7045da6ed8a914690f087690e1e8d662cf9e56f76b445d9dc99c68354c83c102
        I am Satoshi Nakamoto12 => \
        60f01db30c1a0d4cbce2b4b22e88b9b93f58f10555a8f0f4f5da97c3926981c0
        I am Satoshi Nakamoto13 => \
        0ebc56d59a34f5082aaef3d66b37a661696c2b618e62432727216ba9531041a5
        I am Satoshi Nakamoto14 => \
        27ead1ca85da66981fd9da01a8c6816f54cfa0d4834e68a3e2a5477e865164c4
        I am Satoshi Nakamoto15 => \
        394809fb809c5f83ce97ab554a2812cd901d3b164ae93492d5718e15006b1db2
        I am Satoshi Nakamoto16 => \
        8fa4992219df33f50834465d30474298a7d5ec7c7418e642ba6eae6a7b3785b7
        I am Satoshi Nakamoto17 => \
        dca9b8b4f8d8e1521fa4eaa46f4f0cdf9ae0e6939477e1c6d89442b121b8a58e
        I am Satoshi Nakamoto18 => \
        9989a401b2a3a318b01e9ca9a22b0f39d82e48bb51e0d324aaa44ecaba836252
        I am Satoshi Nakamoto19 => \
        cda56022ecb5b67b2bc93a2d764e75fc6ec6e6e79ff6c39e21d03b45aa5b303a
        """
      {:ok, [result: result, expected: expected]}
    end

    test "Example 10-9", %{result: result, expected: expected} do
      assert result == expected
    end
  end

  describe "MasteringBitcoin.ProofOfWorkExample.run()" do
    setup do
      # Running the 0..32 range of difficulty takes too long, so inject
      # a smaller range of difficulty.
      result =
        capture_io(fn -> MasteringBitcoin.ProofOfWorkExample.run(0..5) end)

      {:ok, [result: result]}
    end

    test "Example 10-11", %{result: result} do
      assert result
    end
  end
end
