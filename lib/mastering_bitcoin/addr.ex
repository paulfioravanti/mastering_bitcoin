defmodule MasteringBitcoin.Addr do
  @moduledoc """
  Example 4-3. Creating a Base58Check-encoded bitcoin address from a
  private key.

  Port over of some code contained in the `addr.cpp` file.
  Uses the following libraries to get Elixir talking with C++:

  Porcelain - Reaches out to the shell to compile C++ executable
  Cure - Talks to the C++ code via Ports
  """

  @cpp_executable "priv/addr"
  @cpp_clean "rm #{@cpp_executable}"
  @cpp_compile \
    Application.get_env(:mastering_bitcoin, :cpp_compile)
    |> (fn(cmd) -> Regex.replace(~r/{file}/, cmd, @cpp_executable) end).()
  # Private secret key string as base16
  @private_key "038109007313a5807b2eccc082c8c3fbb988a973cacf1a7df9ce725c31b14776"

  # Integers representing C++ methods
  @generate_public_key 1
  @create_bitcoin_address 2

  def run(r \\ nil) do
    # recompile cpp code
    if r == :r, do: Porcelain.shell(@cpp_clean)
    Porcelain.shell(@cpp_compile)
    with {:ok, pid} <- Cure.Server.start_link(@cpp_executable),
         public_key <- generate_public_key(pid),
         bitcoin_address <- create_bitcoin_address(pid, public_key) do
      IO.puts("Public key: #{inspect(public_key)}")
      IO.puts("Address: #{inspect(bitcoin_address)}")
      :ok = Cure.Server.stop(pid)
    end
  end

  defp generate_public_key(pid) do
    cure_data(pid, <<@generate_public_key, @private_key>>)
  end

  defp create_bitcoin_address(pid, public_key) do
    cure_data(pid, <<@create_bitcoin_address, public_key :: binary>>)
  end

  defp cure_data(pid, data) do
    Cure.send_data(pid, data, :once)
    receive do
      {:cure_data, response} ->
        response
    end
  end
end
