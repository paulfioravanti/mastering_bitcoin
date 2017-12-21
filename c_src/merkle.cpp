// Adapted from the original C++ code located here:
// https://github.com/bitcoinbook/bitcoinbook/blob/second_edition/code/merkle.cpp
#include "elixir_comm.h"
#include <bitcoin/bitcoin.hpp>

bc::hash_digest create_merkle(bc::hash_list& merkle);

int main() {
  int bytes_read;
  byte buffer[MAX_BUFFER_SIZE];
  char hash_literal_1[65];
  char hash_literal_2[65];
  char hash_literal_3[65];

  while ((bytes_read = read_msg(buffer)) > 0) {
    strcpy(hash_literal_1, (char*) &buffer[0]);
    bytes_read = read_msg(buffer);
    strcpy(hash_literal_2, (char*) &buffer[0]);
    bytes_read = read_msg(buffer);
    strcpy(hash_literal_3, (char*) &buffer[0]);

    bc::hash_list tx_hashes{{
      bc::hash_literal(hash_literal_1),
      bc::hash_literal(hash_literal_2),
      bc::hash_literal(hash_literal_3),
    }};

    const bc::hash_digest merkle_root = create_merkle(tx_hashes);
    memcpy(buffer, merkle_root.data(), sizeof(merkle_root));
    send_msg(buffer, merkle_root.size());
  }

  return 0;
}

bc::hash_digest create_merkle(bc::hash_list& merkle) {
  // Stop if hash list is empty.
  if (merkle.empty()) {
    return bc::null_hash;
  } else if (merkle.size() == 1) {
    return merkle[0];
  }

  // While there is more than 1 hash in the list, keep looping...
  while (merkle.size() > 1) {
    // If number of hashes is odd, duplicate last hash in the list.
    if (merkle.size() % 2 != 0) {
      merkle.push_back(merkle.back());
    }
    // List size is now even.
    assert(merkle.size() % 2 == 0);

    // New hash list.
    bc::hash_list new_merkle;
    // Loop through hashes 2 at a time.
    for (auto it = merkle.begin(); it != merkle.end(); it += 2) {
      // Join both current hashes together (concatenate).
      bc::data_chunk concat_data(bc::hash_size * 2);
      auto concat =
        bc::serializer<decltype(concat_data.begin())>(concat_data.begin());
      concat.write_hash(*it);
      concat.write_hash(*(it + 1));
      // Hash both of the hashes.
      bc::hash_digest new_root = bc::bitcoin_hash(concat_data);
      // Add this to the new list.
      new_merkle.push_back(new_root);
    }
    // This is the new list.
    merkle = new_merkle;

    // DEBUG output -------------------------------------
    // NOTE: No way I can get access to this in Elixir-land, so just keep
    // it commented out.
    /* std::cout << "Current merkle hash list:" << std::endl; */
    /* for (const auto &hash: merkle) { */
    /*   std::cout << "  " << bc::encode_base16(hash) << std::endl; */
    /* } */
    /* std::cout << std::endl; */
    // --------------------------------------------------
  }
  // Finally we end up with a single item.
  return merkle[0];
}
