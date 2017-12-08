defmodule MasteringBitcoin.Addr do
  @moduledoc """
  Example 4-3. Creating a Base58Check-encoded bitcoin address from a
  private key.

  Currently a non-port over of the `addr.cpp` file.
  """

  @src_compile """
  g++ -std=c++11 -o priv/addr priv/addr.cpp \
  $(pkg-config --cflags --libs libbitcoin)
  """
  @src_execute "./priv/addr"
  # Private secret key string as base16
  @private_key "038109007313a5807b2eccc082c8c3fbb988a973cacf1a7df9ce725c31b14776"
  @generate_public_key 0

  def run do
    {:ok, server} = Cure.Server.start_link("./c_src/program")
    public_key = generate_public_key(server)
    IO.puts(public_key)
    :ok = Cure.Server.stop(server)
    # Porcelain.shell(@src_compile)

    # @src_execute
    # |> Porcelain.shell()
    # |> Map.fetch!(:out)
    # |> IO.write()
  end

  def generate_public_key(server) do
    Cure.send_data(server, <<@generate_public_key, @private_key>>, :once)
    receive do
      {:cure_data, response} ->
        response
    end
  end
end
