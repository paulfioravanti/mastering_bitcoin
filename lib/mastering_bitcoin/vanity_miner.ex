defmodule MasteringBitcoin.VanityMiner do
  @moduledoc """
  Example 4-9. Vanity address miner

  Currently a non-port over of the `vanity-miner.cpp` file.
  """

  @cpp_executable "priv/vanity-miner"
  @cpp_clean "rm #{@cpp_executable}"
  @cpp_compile \
    Application.get_env(:mastering_bitcoin, :cpp_compile)
    |> (fn(cmd) -> Regex.replace(~r/{file}/, cmd, @cpp_executable) end).()

  def run(r \\ nil) do
    # recompile cpp code
    if r == :r do
      Porcelain.shell(@cpp_clean)
    end
    Porcelain.shell(@cpp_compile)

    "./#{@cpp_executable}"
    |> Porcelain.shell()
    |> Map.fetch!(:out)
    |> IO.write()
  end
end
