# Mastering Bitcoin

This repository contains example code related to the book
[Mastering Bitcoin 2nd Edition][]
([book Github repo][Mastering Bitcoin 2nd Edition Github repo]).

The code examples in the book are all in Python and C++, so I'm _attempting_ to
port them to [Elixir][]. Since Elixir can't use third-party libraries outside of
a mix project, each of the files referenced in the book (eg `rpc_example.py`)
have been ported to an individual module (eg `MasteringBitcoin.RPCExample`) and
their functions can be run inside an `iex` terminal.

I haven't been able to find Elixir libraries that wrap or provide a replacement
for the following libraries:

- [`libbitcoin`][]
- [`pybitcointools`][]
- [`ecdsa`][]

So, for C++ and Python files, source code has been moved out into Elixir as much
as possible, and only code that is responsible for calling language-specific
Bitcoin libraries has been left in the source files.

API-like communication between Elixir and C++ is done using [Cure][] (with
[Porcelain][] being responsible for executing shell commands that compile the
C++ files), and [Export][] is used for communication between Elixir and Python.

## Setup

```sh
git clone git@github.com:paulfioravanti/mastering_bitcoin.git
cd mastering_bitcoin
mix deps.get
```

The book says that:

> If you're reading this book and interested in developing bitcoin software,
> you should be running your own node.

So, that means running a full Bitcoin node on your laptop, and needing to
download the entire blockchain (> 100GB worth of transactions) on to your
computer (there is no way around this). The book gives an example node
configuration file for a resource-constrained system
([Example 3-2][Mastering Bitcoin 2nd Edition Example 3-2]), and that's what I
used to not completely tie up my network and kill my bandwidth limits with
Bitcoin traffic.

Some of the code examples in the book use very specific blockchain transactions
which you may not have yet on your local Bitcoin node. Rather than wait however
many days/weeks it would take to potentially get those specific transactions
before beginning to code, my ported code samples have catch-all conditions that
use other transactions from any available in the local blockchain to generate
any desired outputs.

## Installation

These instructions relate to what I had to do for Mac OSX to get up and running
(your mileage may vary with other operating systems):

### Bitcoin

Use [Homebrew][] to install Bitcoin packages needed for code examples in the
book:

- `bitcoin`: provides `bitcoind` (the Bitcoin daemon) and `bitcoin-cli`
  (the command-line interface that enables communication via Bitcoin's API)
- `libbitcoin`: Various Bitcoin-related helper functions
  (`libbitcoin-explorer` will bring in this library)
- `libbitcoin-explorer`: Libbitcoin's CLI tool. Provides the `bx` command
- `gcc`: Needed to compile the C++ files in the `priv/` directory
- `python`: Needed to run [Python][] files in the `priv/` directory.
  Install either via brew or via a version control manager like [asdf][].

Install brew packages (includes the C++ libraries):

```sh
brew install bitcoin libbitcoin-explorer gcc
```

Install Python packages:

```sh
pip install bitcoin ecdsa
```

The `bitcoin` package comes with a service that can start and stop the
`bitcoind` daemon, so for exercises that require communication with a Bitcoin
node, this will need to be running (but don't forget to turn it off when you
don't need it, especially if you have metered internet!):

```sh
brew services start bitcoin
brew services stop bitcoin
```

### Bitcoin Core

[Bitcoin Core][] is software that contains an example implementation for a
[wallet][bitcoin-wallet], but more importantly, software for a Bitcoin full
node that is needed to query against for the book exercises. It can be
installed using [Homebrew Cask][]:

```sh
brew cask install bitcoin-core
```

Once installed, use your [favourite text editor][vim] to open up the
configuration file located at<br />
`~/Library/Application\ Support/Bitcoin/bitcoin.conf` to configure how much of
your computer's resources the node should use (shown in
[Example 3-1][Mastering Bitcoin 2nd Edition Example 3-1] and
[Example 3-2][Mastering Bitcoin 2nd Edition Example 3-2] in the book).

**NOTE**: even if you use the resource-constrained config in
[Example 3-2][Mastering Bitcoin 2nd Edition Example 3-2], you _must_ do the
following:

- add the `txindex=1` line from
  [Example 3-1][Mastering Bitcoin 2nd Edition Example 3-1]
  to it otherwise you won't be able to make queries on transaction (`tx`)
  IDs via the Bitcoin API (which is something the exercises in the book do).
- remove the `prune=5000` line since Prune Mode is incompatible with `txindex`.
  Attempting to use Prune Mode with `txindex` will result in an error.

### Test local Bitcoin node

Once `bitcoin` and `bitcoin-core` are installed and
`brew services start bitcoin` has been run, you should now be able to use
`bitcoin-cli` to test that everything is working correctly:

```sh
bitcoin-cli getinfo
```

Bitcoin nodes run at `http://localhost:8332` by default, and if you want you can
also use [`curl`][curl] (`brew install curl`) to send API requests to the node:

```sh
curl --user <user>:<password> --data-binary '{"jsonrpc":"1.0","method":"getinfo","params":[]}' http://localhost:8332
```

Replace `<user>` and `<password>` with the relevant values from your<br />
`~/Library/Application\ Support/Bitcoin/bitcoin.conf` file.

### Example code config

Add your Bitcoin node's username and password to the config for the Elixir
example code in the same way as the `curl` command above:

```sh
cp config/config.example.exs config/config.exs
```

Then, edit the `bitcoin_url: "http://<user>:<password>@localhost:8332"` line
of the `config.exs` file and substitute out the user and password information.

### Run the code

Start the Bitcoin service, open up an `iex` console, and run the functions.
For example:

```sh
brew services start bitcoin
iex -S mix
```

Example of interacting with the Bitcoin node:

```elixir
iex(1)> MasteringBitcoin.Client.getinfo()
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

Example of running Elixir files that require compilation of C++ files (if there
are any compiliation failures on your system, you may need to tweak the
`cpp_compile` command specified in `config/config.exs`):

```elixir
iex(1)> MasteringBitcoin.Addr.run()
Public key: 0202a406624211f2abbdc68da3df929f938c3399dd79fac1b51b0e4ad1d26a47aa
Address: 1PRTTaJesdNovgne6Ehcdu1fpEdX7913CK
:ok
```

Example of running Elixir files that require Python libraries:

```elixir
iex(1)> MasteringBitcoin.ECMath.run()
Secret: 76497699402904578784811806082397843232750285367593369208731087007120587404213
EC point: {57239427007104299630483439879927188058287895941305706210701488924875951881267, 52165304091649203337605762013611225541526214366439596521175895001167065705415}
BTC public key: "037e8c5e1b2a6e9233c19ba8b29881af555d13adb7e50a0ac926fc52b1370abc33"
:ok
```

## Tests

Each of the exercises has a sanity test check to just make sure it works, and
continues to work as expected.

### Run the test suite

```sh
mix test
```

The test suite deliberately excludes tests for files that require a Bitcoin node
to be running, as those tests require `brew services start bitcoin` to be run,
and warming up the node can take a variable length of time, leading to
potential test suite failures. However, they _do_ actually work, and can be
specifically included when running the test suite:

```sh
mix test --include bitcoin_server
```

[mix test.watch][] is included in this project, and hence all the tests
(excluding `bitcoin_server` tests), as well as [Credo][] and [Dogma][] checks,
can be continuously run when file changes are made:

```sh
mix test.watch
```

## Helpful Resources

- [Controlling a Bitcode Node in Elixir][]
- [Using Python's Bitcoin libraries in Elixir][]
  (A blog post I did about this very repo)

## Social

[![Contact][twitter-badge]][twitter-url]<br />
[![Stack Overflow][stackoverflow-badge]][stackoverflow-url]

[asdf]: https://github.com/asdf-vm/asdf
[Bitcoin Core]: https://bitcoin.org/en/bitcoin-core/
[bitcoin-wallet]: https://en.bitcoin.it/wiki/Wallet
[Controlling a Bitcode Node in Elixir]: http://www.east5th.co/blog/2017/09/04/controlling-a-bitcoin-node-with-elixir/
[Credo]: https://github.com/rrrene/credo
[Cure]: https://github.com/luc-tielen/Cure
[curl]: https://curl.haxx.se/
[Dogma]: https://github.com/lpil/dogma
[`ecdsa`]: https://github.com/warner/python-ecdsa
[Elixir]: https://github.com/elixir-lang/elixir
[Export]: https://github.com/fazibear/export
[Homebrew]: https://github.com/Homebrew/brew
[Homebrew Cask]: https://github.com/caskroom/homebrew-cask
[`libbitcoin`]: https://github.com/libbitcoin/libbitcoin
[Mastering Bitcoin 2nd Edition]: https://www.amazon.com/Mastering-Bitcoin-Programming-Open-Blockchain/dp/1491954388
[Mastering Bitcoin 2nd Edition Example 3-1]: https://github.com/bitcoinbook/bitcoinbook/blob/second_edition/ch03.asciidoc#full_index_node
[Mastering Bitcoin 2nd Edition Example 3-2]: https://github.com/bitcoinbook/bitcoinbook/blob/second_edition/ch03.asciidoc#constrained_resources
[Mastering Bitcoin 2nd Edition Github repo]: https://github.com/bitcoinbook/bitcoinbook
[mix test.watch]: https://github.com/lpil/mix-test.watch
[Porcelain]: https://github.com/alco/porcelain
[`pybitcointools`]: https://github.com/vbuterin/pybitcointools
[Python]: https://www.python.org/
[stackoverflow-badge]: http://stackoverflow.com/users/flair/567863.png
[stackoverflow-url]: http://stackoverflow.com/users/567863/paul-fioravanti
[twitter-badge]: https://img.shields.io/badge/contact-%40paulfioravanti-blue.svg
[twitter-url]: https://twitter.com/paulfioravanti
[Using Python's Bitcoin libraries in Elixir]: https://paulfioravanti.com/elixir/bitcoin/2017/12/04/using-pythons-bitcoin-libraries-in-Elixir.html
[vim]: http://www.vim.org/
