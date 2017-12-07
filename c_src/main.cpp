#include <bitcoin/bitcoin.hpp>
#include <iostream>
#include <fstream>
#include <string>

#include "main.h"

using namespace std;

int main(void)
{
    int bytes_read;
    byte buffer[MAX_BUFFER_SIZE];

    while((bytes_read = read_msg(buffer)) > 0)
    {
        // TODO put C-code here, right now it only echos data back
        // to Elixir.
        std::string pub_key = generate_public_key(buffer);

        // Send public key back to Elixir
        memcpy(buffer, pub_key.data(), pub_key.length());
        send_msg(buffer, pub_key.size());
    }

    return 0;
}

std::string generate_public_key(std::string priv_key)
{
    bc::ec_secret decoded;
    bc::decode_base16(decoded, priv_key);

    bc::wallet::ec_private secret(
        decoded, bc::wallet::ec_private::mainnet_p2kh);

    // Get public key.
    bc::wallet::ec_public public_key(secret);
    return public_key.encoded();
}
