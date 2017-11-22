import ecdsa

def public_key_elliptic_curve_point(p, a, b, gx, gy, r, secret):
  point = elliptic_curve_point(p, a, b, gx, gy, r)
  return public_key_point(point, secret)

def elliptic_curve_point(p, a, b, gx, gy, r):
  curve_secp256k1 = ecdsa.ellipticcurve.CurveFp(p, a, b)
  return ecdsa.ellipticcurve.Point(curve_secp256k1, gx, gy, r)

def public_key_point(point, secret):
  public_key_point = secret * point
  return (public_key_point.x(), public_key_point.y())
