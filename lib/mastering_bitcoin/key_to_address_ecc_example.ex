defmodule MasteringBitcoin.KeyToAddressECCExample do
  @moduledoc """
  Example 4-5. Key and address generation and formatting with the
  pybitcointools library.

  Port over of most code contained in the `key-to-address-ecc-example.py` file,
  and uses the Export library to talk to Python-based bitcoin libraries.
  """

  # Elliptic curve parameters (secp256k1)
  # REF: https://github.com/vbuterin/pybitcointools/blob/master/bitcoin/main.py
  @n 115792089237316195423570985008687907852837564279074904382605163141518161494337
  @gx 55066263022277343669578718895168534326250603453777594175500187360389116729240
  @gy 32670510020758816978083085130507043184471273380659243275938904335757337482424
  @g {@gx, @gy}

  @python_src :code.priv_dir(:mastering_bitcoin) |> Path.basename()
  @python_file "key-to-address-ecc-example"
  @compression_suffix "01"
  @hex "hex"
  @wif "wif"
  @hex_encoder 16

  use Export.Python
  require Integer

  def run do
    with {:ok, pid} <- Python.start(python_path: @python_src),
         [private_key, decoded_private_key] <- generate_private_key(pid),
         wif_encoded_private_key <- encode_private_key(pid, decoded_private_key),
         compressed_private_key <- create_compressed_private_key(private_key),
         wif_compressed_private_key <-
           encode_compressed_private_key(pid, compressed_private_key),
         public_key <- fast_multiply(pid, decoded_private_key),
         hex_encoded_public_key <- encode_public_key(pid, public_key),
         hex_compressed_public_key <- compress_public_key(pid, public_key),
         bitcoin_address <- generate_bitcoin_address(pid, public_key),
         compressed_bitcoin_address <-
           generate_bitcoin_address(pid, hex_compressed_public_key) do
      IO.puts("Private Key (hex) is: #{inspect(private_key)}")
      IO.puts("Private Key (decimal) is: #{inspect(decoded_private_key)}")
      IO.puts("Private Key (WIF) is: #{inspect(wif_encoded_private_key)}")
      IO.puts("""
      Private Key Compressed (hex) is: #{inspect(compressed_private_key)}\
      """)
      IO.puts("""
      Private Key (WIF Compressed) is: #{inspect(wif_compressed_private_key)}\
      """)
      IO.puts("Public Key (x,y) coordinates is: #{inspect(public_key)}")
      IO.puts("Public Key (hex) is: #{inspect(hex_encoded_public_key)}")
      IO.puts("Bitcoin Address (b58check) is: #{inspect(bitcoin_address)}")
      IO.puts("""
      Compressed Bitcoin Address (b58check) is: \
      #{inspect(compressed_bitcoin_address)}\
      """)
      Python.stop(pid)
    end
  end

  # Generate a random private key
  defp generate_private_key(pid) do
    with private_key <- random_key(pid),
         decoded_private_key <- decode_private_key(pid, private_key) do
      case decoded_private_key do
        n when n in 0..@n ->
          [private_key, decoded_private_key]
        _out_of_range ->
          generate_private_key(pid)
      end
    end
  end

  # Add suffix "01" to indicate a compressed private key
  defp create_compressed_private_key(private_key) do
    private_key <> @compression_suffix
  end

  defp random_key(pid) do
    pid
    |> Python.call(@python_file, "bitcoin.random_key", [])
    |> to_string()
  end

  defp decode_private_key(pid, private_key) do
    pid
    |> Python.call(@python_file, "decode_privkey", [private_key, @hex])
    |> to_string()
    |> String.to_integer()
  end

  # Convert private key to WIF format
  defp encode_private_key(pid, decoded_private_key) do
    pid
    |> Python.call(@python_file, "encode_privkey", [decoded_private_key, @wif])
    |> to_string()
  end

  defp encode_compressed_private_key(pid, compressed_private_key) do
    pid
    |> decode_private_key(compressed_private_key)
    |> (fn(decoded_pk) -> encode_private_key(pid, decoded_pk) end).()
  end

  # Multiply the EC generator point G with the private key to get a
  # public key point
  defp fast_multiply(pid, decoded_private_key) do
    Python.call(
      pid, @python_file, "bitcoin.fast_multiply", [@g, decoded_private_key]
    )
  end

  # Encode as hex, prefix 04
  defp encode_public_key(pid, public_key) do
    pid
    |> Python.call(@python_file, "encode_pubkey", [public_key, @hex])
    |> to_string()
  end

  # Compress public key, adjust prefix depending on whether y is even or odd
  defp compress_public_key(pid, {public_key_x, public_key_y}) do
    compressed_prefix =
      if Integer.is_even(public_key_y), do: "02", else: "03"

    pid
    |> Python.call(@python_file, "bitcoin.encode", [public_key_x, @hex_encoder])
    |> to_string()
    |> (fn(encoded_pk) -> compressed_prefix <> encoded_pk end).()
  end

  # Generate bitcoin address from public key (hex or compressed)
  defp generate_bitcoin_address(pid, public_key) do
    pid
    |> Python.call(@python_file, "bitcoin.pubkey_to_address", [public_key])
    |> to_string()
  end
end
