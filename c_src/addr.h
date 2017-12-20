// Adapted from the original C++ code located here:
// https://github.com/bitcoinbook/bitcoinbook/blob/second_edition/code/addr.cpp
#ifndef ADDR_H
#define ADDR_H
#include "elixir_comm.h"

std::string generate_public_key(std::string priv_key);
std::string create_bitcoin_address(std::string pub_key);

// Helper functions
// REF: https://github.com/asbaker/elixir-interop-examples/blob/master/serial_ports/c_src/serial.c
void process_command(byte* buffer, int bytes_read);

#endif
