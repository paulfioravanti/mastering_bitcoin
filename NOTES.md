brew install bitcoin # provides bitcoind and bitcoin-cli
brew services start bitcoin

brew cask install bitcoin-core # wallet/full node

bitcoin-cli getinfo
curl --user bitcoinrpc:fngtwuqK4PuCpf98wKqRN3uE6M3K6NsNsRqNRooPAUs3mfTBJYbV4BB7CttFJiGT --data-binary '{"jsonrpc":"1.0","method":"getinfo","params":[]}' http://localhost:8332

--------------

bitcoin-cli getblockhash 1000
curl --user bitcoinrpc:fngtwuqK4PuCpf98wKqRN3uE6M3K6NsNsRqNRooPAUs3mfTBJYbV4BB7CttFJiGT --data-binary '{"jsonrpc":"1.0","method":"getblockhash","params":[1000]}' http://localhost:8332


-----

Add -txindex in order to make queries on transaction IDs
Do this in ~/Library/LaunchAgents/homebrew.mxcl.bitcoin.plist

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>homebrew.mxcl.bitcoin</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/local/opt/bitcoin/bin/bitcoind -txindex</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
