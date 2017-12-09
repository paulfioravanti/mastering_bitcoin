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
      # A static code analysis tool for the Elixir language
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      # Interface C-code with Erlang/Elixir using Ports
      {:cure, "~> 0.4.0"},
      # Erlport wrapper for Elixir to interface with Python code
      {:export, "~> 0.1.0"},
      # HTTP client for Elixir powered by hackney
      {:httpoison, "~> 0.13"},
      # Automatically run your Elixir project's tests each time you save a file
      {:mix_test_watch, "~> 0.3", only: :dev, runtime: false},
      # An incredibly fast, pure Elixir JSON library
      {:poison, "~> 3.1"},
      # Work with external processes
      {:porcelain, "~> 2.0"}
    ]
  end
end
