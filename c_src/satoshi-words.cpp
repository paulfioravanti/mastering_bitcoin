// Adapted from the original C++ code located here:
// https://github.com/bitcoinbook/bitcoinbook/blob/second_edition/code/satoshi-words.cpp
/*
  Display the genesis block message by Satoshi.
*/
#include "elixir_comm.h"
#include <bitcoin/bitcoin.hpp>

int main() {
  int bytes_read;
  byte buffer[MAX_BUFFER_SIZE];

  while ((bytes_read = read_msg(buffer)) > 0) {
    // Create genesis block.
    bc::chain::block block = bc::chain::block::genesis_mainnet();
    // Genesis block contains a single coinbase transaction.
    assert(block.transactions().size() == 1);
    // Get first transaction in block (coinbase).
    const bc::chain::transaction& coinbase_tx = block.transactions()[0];
    // Coinbase tx has a single input.
    assert(coinbase_tx.inputs().size() == 1);
    const bc::chain::input& coinbase_input = coinbase_tx.inputs()[0];
    // Convert the input script to its raw format.
    const auto prefix = false;
    const bc::data_chunk& raw_message = coinbase_input.script().to_data(prefix);
    // Convert this to a std::string.
    // REF: https://github.com/libbitcoin/libbitcoin/blob/master/test/chain/satoshi_words.cpp
    std::string message;
    message.resize(raw_message.size() - 8);
    std::copy(raw_message.begin() + 8, raw_message.end(), message.begin());

    memcpy(buffer, message.data(), message.length());
    send_msg(buffer, message.size());
  }
  return 0;
}
