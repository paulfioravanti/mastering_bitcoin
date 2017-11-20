defmodule MasteringBitcoin.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mastering_bitcoin,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # HTTP client for Elixir powered by hackney
      {:httpoison, "~> 0.13"},
      # An incredibly fast, pure Elixir JSON library
      {:poison, "~> 3.1"},
      # Work with external processes
      {:porcelain, "~> 2.0"}
    ]
  end
end
