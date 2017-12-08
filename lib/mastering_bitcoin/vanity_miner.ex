defmodule MasteringBitcoin.VanityMiner do
  @moduledoc """
  Example 4-9. Vanity address miner

  Port over of some code contained in the `vanity-miner.cpp` file.
  Uses the following libraries to get Elixir talking with C++:

  Porcelain - Reaches out to the shell to compile C++ executable
  Cure - Talks to the C++ code via Ports
  """

  @cpp_executable "priv/vanity-miner"
  @cpp_clean "rm #{@cpp_executable}"
  @cpp_compile \
    Application.get_env(:mastering_bitcoin, :cpp_compile)
    |> (fn(cmd) -> Regex.replace(~r/{file}/, cmd, @cpp_executable) end).()
  @vanity_string "1kid"

  def run(r \\ nil) do
    # recompile cpp code
    if r == :r, do: Porcelain.shell(@cpp_clean)
    Porcelain.shell(@cpp_compile)

    with {:ok, pid} <- Cure.Server.start_link(@cpp_executable),
         [vanity_address, secret] <- generate_vanity_address(pid) do
      IO.puts("Found vanity address! #{inspect(vanity_address)}")
      IO.puts("Secret: #{inspect(secret)}")
      :ok = Cure.Server.stop(pid)
    end
  end

  defp generate_vanity_address(pid) do
    Cure.send_data(pid, @vanity_string, :permanent)
    vanity_address =
      receive do
        {:cure_data, response} ->
          response
      end
    secret =
      receive do
        {:cure_data, response} ->
          response
      end
    [vanity_address, secret]
  end
end
