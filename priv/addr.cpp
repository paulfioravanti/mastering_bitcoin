// Adapted from the original C++ code located here:
// https://github.com/bitcoinbook/bitcoinbook/blob/second_edition/code/addr.cpp
#include <bitcoin/bitcoin.hpp>
#include "addr.h"

const int GENERATE_PUBLIC_KEY = 1;
const int CREATE_BITCOIN_ADDRESS = 2;

int main(void) {
  int bytes_read;
  byte buffer[MAX_BUFFER_SIZE];

  while ((bytes_read = read_msg(buffer)) > 0) {
    process_command(buffer, bytes_read);
  }

  return 0;
}

// Process the command dependent on the integer value given in the message
// sent from Elixir
void process_command(byte* buffer, int bytes_read) {
  int function = buffer[0];
  char arg[1024];
  get_string_arg(buffer, arg, bytes_read);
  std::string retval;

  if (bytes_read > 0) {
    switch (function) {
      case GENERATE_PUBLIC_KEY:
        retval = generate_public_key(arg);
        break;
      case CREATE_BITCOIN_ADDRESS:
        retval = create_bitcoin_address(arg);
        break;
      default:
        fprintf(stderr, "not a valid function %i\n", function);
        exit(1);
    }
    memcpy(buffer, retval.data(), retval.length());
    send_msg(buffer, retval.size());
  } else {
    fprintf(stderr, "no command given");
    exit(1);
  }
}

void get_string_arg(byte* buffer, char* string, int bytes_read) {
  buffer[bytes_read] = '\0';
  strcpy(string, (char*) &buffer[1]);
}

std::string generate_public_key(std::string priv_key) {
  bc::ec_secret decoded;
  bc::decode_base16(decoded, priv_key);

  bc::wallet::ec_private secret(decoded, bc::wallet::ec_private::mainnet_p2kh);

  // Get public key.
  bc::wallet::ec_public public_key(secret);
  return public_key.encoded();
}

std::string create_bitcoin_address(std::string pub_key) {
  // Create Bitcoin address.
  // Normally you can use:
  //    bc::wallet::payment_address payaddr =
  //        public_key.to_payment_address(
  //            bc::wallet::ec_public::mainnet_p2kh);
  //  const std::string address = payaddr.encoded();

  bc::wallet::ec_public public_key = bc::wallet::ec_public::ec_public(pub_key);
  // Compute hash of public key for P2PKH address.
  bc::data_chunk public_key_data;
  public_key.to_data(public_key_data);
  const auto hash = bc::bitcoin_short_hash(public_key_data);

  bc::data_chunk unencoded_address;
  // Reserve 25 bytes
  //   [ version:1  ]
  //   [ hash:20    ]
  //   [ checksum:4 ]
  unencoded_address.reserve(25);
  // Version byte, 0 is normal BTC address (P2PKH).
  unencoded_address.push_back(0);
  // Hash data
  bc::extend_data(unencoded_address, hash);
  // Checksum is computed by hashing data, and adding 4 bytes from hash.
  bc::append_checksum(unencoded_address);
  // Finally we must encode the result in Bitcoin's base58 encoding.
  assert(unencoded_address.size() == 25);
  const std::string address = bc::encode_base58(unencoded_address);
  return address;
}
