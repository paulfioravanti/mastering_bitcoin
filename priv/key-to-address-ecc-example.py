# Adapted from the original Python script located here:
# https://github.com/bitcoinbook/bitcoinbook/blob/second_edition/code/key-to-address-ecc-example.py
#
# The goal was to make this script act more like an API wrapper around Python's
# bitcoin library that the Elixir code could call.
# Where possible, the Elixir code calls methods on `bitcoin` directly, but there
# are cases where strings passed via erlport need to be parsed/decoded on the
# python side, and that's why the methods below exist.
#
# NOTE: All methods that accept strings from Elixir have to be decoded into
# UTF-8 in order to work correctly. Elixir passes strings to Python as a
# sequence of bytes, interpreted as `b'...'` literals in Python 3.
# Without the decoding, errors happen.
# REF: https://stackoverflow.com/questions/6269765/what-does-the-b-character-do-in-front-of-a-string-literal
import bitcoin

# NOTE: public_key is a tuple
def encode_pubkey(public_key, encoder):
  return bitcoin.encode_pubkey(public_key, encoder.decode())

def encode_privkey(decoded_private_key, encoder):
  return bitcoin.encode_privkey(decoded_private_key, encoder.decode())

def decode_privkey(private_key, decoder):
  return bitcoin.decode_privkey(private_key, decoder.decode())

# 64 represents the minimum length of the string required returned back.
# Zeros will be prepended to a string until it meets the length requirement.
# Less characters than 64 will result in an invalid public key.
def encode(public_key_x, encoder):
  return bitcoin.encode(public_key_x, encoder, 64)
