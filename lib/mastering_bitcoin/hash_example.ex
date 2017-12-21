defmodule MasteringBitcoin.HashExample do
  @moduledoc """
  Example 10-9. SHA256 script for generating many hashes by iterating on
  a nonce.

  Port over of `hash_example.py` file.
  """

  @text "I am Satoshi Nakamoto"

  def run do
    # iterate nonce from 0 to 19
    Enum.each(0..19, fn(nonce) ->
      input = "#{@text}#{nonce}"
      # add the nonce to the end of the text
      # calculate the SHA-256 hash of the input (text+nonce)
      :sha256
      |> :crypto.hash(input)
      |> Base.encode16(case: :lower)
      |> (fn(hash) -> IO.puts("#{input} => #{hash}") end).()
    end)
  end
end
