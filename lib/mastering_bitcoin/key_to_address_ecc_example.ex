defmodule MasteringBitcoin.KeyToAddressECCExample do
  @moduledoc """
  Example 4-5. Key and address generation and formatting with the
  pybitcointools library.

  Uses the Export library (that wraps erlport) to talk to Python.
  """

  @python_src "src"
  @python_file "key-to-address-ecc-example"
  @compression_suffix "01"
  @hex "hex"
  @wif "wif"

  use Export.Python

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
      IO.puts("Private Key (hex) is: #{private_key}")
      IO.puts("Private Key (decimal) is: #{decoded_private_key}")
      IO.puts("Private Key (WIF) is: #{wif_encoded_private_key}")
      IO.puts("Private Key Compressed (hex) is: #{compressed_private_key}")
      IO.puts("Private Key (WIF Compressed) is: #{wif_compressed_private_key}")
      IO.puts("Public Key (x,y) coordinates is: #{inspect(public_key)}")
      IO.puts("Public Key (hex) is: #{hex_encoded_public_key}")
      IO.puts("Bitcoin Address (b58check) is: #{bitcoin_address}")
      IO.puts("""
      Compressed Bitcoin Address (b58check) is: #{compressed_bitcoin_address}\
      """)
      Python.stop(pid)
    end
  end

  # Generate a random private key
  defp generate_private_key(pid) do
    with private_key <- random_key(pid),
         decoded_private_key <- decode_private_key(pid, private_key),
         bitcoin_n <- fetch_bitcoin_n(pid) do
      if 0 < decoded_private_key && decoded_private_key < bitcoin_n do
        [private_key, decoded_private_key]
      else
        generate_private_key(pid)
      end
    end
  end

  # Add suffix "01" to indicate a compressed private key
  defp create_compressed_private_key(private_key) do
    private_key <> @compression_suffix
  end

  defp random_key(pid) do
    python(pid, "bitcoin.random_key", [])
  end

  defp decode_private_key(pid, private_key) do
    python(pid, "decode_privkey", [private_key, @hex])
  end

  defp fetch_bitcoin_n(pid) do
    python(pid, "bitcoin_n", [])
  end

  # Convert private key to WIF format
  defp encode_private_key(pid, decoded_private_key) do
    python(pid, "encode_privkey", [decoded_private_key, @wif])
  end

  defp encode_compressed_private_key(pid, compressed_private_key) do
    decoded_private_key = decode_private_key(pid, compressed_private_key)
    encode_private_key(pid, decoded_private_key)
  end

  # Multiply the EC generator point G with the private key to get a
  # public key point
  defp fast_multiply(pid, decoded_private_key) do
    bitcoin_g = Python.call(pid, @python_file, "bitcoin_g", [])
    Python.call(
      pid, @python_file, "fast_multiply", [bitcoin_g, decoded_private_key]
    )
  end

  # Encode as hex, prefix 04
  defp encode_public_key(pid, public_key) do
    python(pid, "encode_pubkey", [public_key, @hex])
  end

  # Compress public key, adjust prefix depending on whether y is even or odd
  defp compress_public_key(pid, {public_key_x, public_key_y}) do
    compressed_prefix =
      case Integer.mod(public_key_y, 2) do
        0 -> "02"
        _ -> "03"
      end
    compressed_prefix <> python(pid, "encode", [public_key_x, 16])
  end

  # Generate bitcoin address from public key (hex or compressed)
  def generate_bitcoin_address(pid, public_key) do
    python(pid, "pubkey_to_address", [public_key])
  end

  defp python(pid, function, arguments) do
    pid
    |> Python.call(@python_file, function, arguments)
    |> to_string()
  end
end
