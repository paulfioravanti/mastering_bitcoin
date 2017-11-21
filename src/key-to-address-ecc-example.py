# Adapted from the original Python script located here:
# https://github.com/bitcoinbook/bitcoinbook/blob/second_edition/code/key-to-address-ecc-example.py
# The goal was to make this script act more like an API wrapper around Python's
# bitcoin library that the Elixir code could call.
# Where possible, the Elixir code calls methods on `bitcoin` directly, but there
# are cases where parameters passed via erlport need to be parsed/decoded on the
# python side, or a non-method constant like bitcoin.G is needed, and that's
# why the methods below exist.
#
# NOTE: All methods that accept strings from Elixir have to be decoded into
# UTF-8 in order to work correctly. Elixir passes strings to Python as a
# sequence of bytes, interpreted as `b'...'` literals in Python 3.
# Without the decoding, errors happen.
# REF: https://stackoverflow.com/questions/6269765/what-does-the-b-character-do-in-front-of-a-string-literal
import bitcoin

# NOTE: public_key is a tuple
def encode_pubkey(public_key, encoder):
  encoder = encoder.decode()
  return bitcoin.encode_pubkey(public_key, encoder)

def encode_privkey(decoded_private_key, encoder):
  # NOTE: decoded private key must be decoded first into a string before
  # parsing to an integer. Method like int.from_bytes will not give back
  # the correct value.
  decoded_private_key = int(decoded_private_key.decode())
  encoder = encoder.decode()
  return bitcoin.encode_privkey(decoded_private_key, encoder)

def decode_privkey(private_key, decoder):
  private_key = private_key.decode()
  decoder = decoder.decode()
  return bitcoin.decode_privkey(private_key, decoder)

# NOTE: bitcoin_g is a tuple, and this method returns a tuple
def fast_multiply(bitcoin_g, decoded_private_key):
  # NOTE: decoded private key must be decoded first into a string before
  # parsing to an integer. Method like int.from_bytes will not give back
  # the correct value.
  decoded_private_key = int(decoded_private_key.decode())
  return bitcoin.fast_multiply(bitcoin_g, decoded_private_key)

def bitcoin_n():
  return bitcoin.N

# NOTE: This returns a tuple
def bitcoin_g():
  return bitcoin.G
