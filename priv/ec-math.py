# Adapted from the original Python script located here:
# https://github.com/bitcoinbook/bitcoinbook/blob/second_edition/code/ec-math.py
#
# The goal was to make this script act more like an API wrapper around Python's
# ecdsa library that the Elixir code could call.
import ecdsa

def public_key_elliptic_curve_point(p, a, b, gx, gy, r, secret):
  point = __elliptic_curve_point(p, a, b, gx, gy, r)
  return __public_key_point(point, secret)

def __elliptic_curve_point(p, a, b, gx, gy, r):
  curve_secp256k1 = ecdsa.ellipticcurve.CurveFp(p, a, b)
  return ecdsa.ellipticcurve.Point(curve_secp256k1, gx, gy, r)

def __public_key_point(point, secret):
  public_key_point = secret * point
  return (public_key_point.x(), public_key_point.y())
