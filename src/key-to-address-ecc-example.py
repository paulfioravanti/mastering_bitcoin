# Adapted from the original Python script located here:
# https://github.com/bitcoinbook/bitcoinbook/blob/second_edition/code/key-to-address-ecc-example.py
# The goal was to make this script act more like an API wrapper around Python's
# bitcoin library that the Elixir code could call.
#
# NOTE: All methods that accept strings from Elixir have to be decoded into
# UTF-8 in order to work correctly. Elixir passes strings to Python as a
# sequence of bytes, interpreted as `b'...'` literals in Python 3.
# Without the decoding, errors happen.
# REF: https://stackoverflow.com/questions/6269765/what-does-the-b-character-do-in-front-of-a-string-literal
import bitcoin

ENCODING = "UTF-8"

def encode(string, encoder):
  return bitcoin.encode(string, encoder)

# NOTE: public_key is a tuple
def encode_pubkey(public_key, encoder):
  encoder = encoder.decode(ENCODING)
  return bitcoin.encode_pubkey(public_key, encoder)

def encode_privkey(decoded_private_key, encoder):
  # NOTE: decoded private key must be decoded first into a string before
  # parsing to an integer. Method like int.from_bytes will not give back
  # the correct value.
  decoded_private_key = int(decoded_private_key.decode(ENCODING))
  encoder = encoder.decode(ENCODING)
  return bitcoin.encode_privkey(decoded_private_key, encoder)

def decode_privkey(private_key, decoder):
  private_key = private_key.decode(ENCODING)
  decoder = decoder.decode(ENCODING)
  return bitcoin.decode_privkey(private_key, decoder)

# NOTE: bitcoin_g is a tuple, and this method returns a tuple
def fast_multiply(bitcoin_g, decoded_private_key):
  # NOTE: decoded private key must be decoded first into a string before
  # parsing to an integer. Method like int.from_bytes will not give back
  # the correct value.
  decoded_private_key = int(decoded_private_key.decode(ENCODING))
  return bitcoin.fast_multiply(bitcoin_g, decoded_private_key)

def bitcoin_n():
  return bitcoin.N

# NOTE: This returns a tuple
def bitcoin_g():
  return bitcoin.G

def pubkey_to_address(public_key):
  return bitcoin.pubkey_to_address(public_key)
