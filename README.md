# Mastering Bitcoin

This repository contains example code related to the book
[Mastering Bitcoin 2nd Edition][]
([book Github repo][Mastering Bitcoin 2nd Edition Github repo]).

The code examples in the book are all in Python and C++, so I decided to port
them to [Elixir][]. Since Elixir can't use third-party libraries outside of a
mix project, each of the files referenced in the book (eg `rpc_example.py`)
have been ported to an individual module (eg `MasteringBitcoin.RPCExample`) and
their functions can be run inside an `iex` terminal.

## Setup

```
$ git clone git@github.com:paulfioravanti/mastering_bitcoin.git
$ cd mastering_bitcoin
$ mix deps.get
```

The books says that:

> If you're reading this book and interested in developing bitcoin software,
> you should be running your own node.

So, that means running a full Bitcoin node on your laptop, and needing to
download the entire blockchain (> 100GB worth of transactions) on to your
computer. The book gives an example node configuration file for a
resource-constrained system
([Example 3-2][Mastering Bitcoin 2nd Edition Example 3-2]), and that's what I
used to not completely tie up my network and kill my bandwidth limits with
Bitcoin traffic.

Some of the code examples in the book use very specific blockchain transactions
which you may not have on your local Bitcoin node. Rather than wait however many
days/weeks it would take to potentially get those specific transactions before
beginning to code, my ported code samples have catch-all conditions that use
other transactions from any available in the local blockchain to generate any
desired outputs.

## Installation

These instructions relate to what I had to do for Mac OSX to get up and running:

### Bitcoin

Use [Homebrew][] to install the `bitcoin` package, that provides `bitcoind`
(the Bitcoin daemon) and `bitcoin-cli` (the command-line interface that enables
communication via Bticoin's API):

```
$ brew install bitcoin
```

This package comes with a service that can start and stop the `bitcoind`
daemon:

```
$ brew services start bitcoin
$ brew services stop bitcoin
```

### Bitcoin Core

Bitcoin Core is software that contains an example implementation for a
wallet, but more importantly, software for a Bitcoin full node that is needed
to query against for the book exercises. It can be installed using
[Homebrew Cask][]:

```
$ brew cask install bitcoin-core
```

Once installed, use your favourite text editor to open up the configuration file
located at `~/Library/Application\ Support/Bitcoin/bitcoin.conf` to
configure how much of your computer's resources the node should use
(shown in [Example 3-1][Mastering Bitcoin 2nd Edition Example 3-1] and
([Example 3-2][Mastering Bitcoin 2nd Edition Example 3-2] in the book).

**NOTE**: even if you use the resource-constrained config in Example 3-2,
you _must_ add the `txindex=1` line from Example 3-1 to it otherwise you won't
be able to make queries on transaction (tx) IDs via the Bitcoin API (which is
something the exercises in the book do).

### Test local Bitcoin node

Once `bitcoin` and `bitcoin-core` are installed and
`$ brew services start bitcoin` has been run, you should now be able to use
`bitcoin-cli` to test that everything is working correctly:

```
$ bitcoin-cli getinfo
```

Bitcoin nodes run at `http://localhost:8332` by default, so you can also use
[`curl`][Curl] (`$ brew install curl`) to send API requests
to the node:

```
curl --user <user>:<password> --data-binary '{"jsonrpc":"1.0","method":"getinfo","params":[]}' http://localhost:8332
```

Replace `<user>` and `<password>` with the relevant values from your
`~/Library/Application\ Support/Bitcoin/bitcoin.conf` file.

### Example code config

Add your Bitcoin node's username and password to the config for the Elixir
example code in the same way as the `curl` command above:

```
$ cp config/config.example.exs config/config.exs
```

Then, edit the `bitcoin_url: "http://<user>:<password>@localhost:8332"` line
of the `config.exs` file and substitute out the user and password information.

### Run the code

Start the Bitcoin service, open up an `iex` console, and run the functions.
For example:

```
$ brew services start bitcoin
$ iex -S mix
iex(1)> MasteringBitcoin.Client.getinfo
{:ok,
 %{"balance" => 0.0, "blocks" => 375964, "connections" => 8,
   "difficulty" => 59335351233.86657, "errors" => "",
   "keypoololdest" => 1508115486, "keypoolsize" => 1000, "paytxfee" => 0.0,
   "protocolversion" => 70015, "proxy" => "", "relayfee" => 0.0001,
   "testnet" => false, "timeoffset" => -3, "version" => 140200,
   "walletversion" => 130000}}
iex(2)> MasteringBitcoin.RPCExample.run
375945
:ok
```

## Helpful Resources

- [Controlling a Bitcode Node in Elixir][]

[Controlling a Bitcode Node in Elixir]: http://www.east5th.co/blog/2017/09/04/controlling-a-bitcoin-node-with-elixir/
[Curl]: https://curl.haxx.se/
[Elixir]: https://github.com/elixir-lang/elixir
[Homebrew]: https://github.com/Homebrew/brew
[Homebrew Cask]: https://github.com/caskroom/homebrew-cask
[Mastering Bitcoin 2nd Edition]: https://www.amazon.com/Mastering-Bitcoin-Programming-Open-Blockchain/dp/1491954388
[Mastering Bitcoin 2nd Edition Example 3-1]: https://github.com/bitcoinbook/bitcoinbook/blob/second_edition/ch03.asciidoc#full_index_node
[Mastering Bitcoin 2nd Edition Example 3-2]: https://github.com/bitcoinbook/bitcoinbook/blob/second_edition/ch03.asciidoc#constrained_resources
[Mastering Bitcoin 2nd Edition Github repo]: https://github.com/bitcoinbook/bitcoinbook
