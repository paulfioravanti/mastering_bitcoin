// Adapted from the original C++ code located here:
// https://github.com/bitcoinbook/bitcoinbook/blob/second_edition/code/vanity-miner.cpp
#ifndef VANITY_MINER_H
#define VANITY_MINER_H
#include "elixir_comm.h"

bc::ec_secret random_secret(std::default_random_engine& engine);
// Extract the Bitcoin address from an EC secret.
std::string bitcoin_address(const bc::ec_secret& secret);
// Case insensitive comparison with the search string.
bool match_found(const std::string& address, const std::string search);

#endif
