defmodule ExPlayground.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_playground,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {ExPlayground, []},
     applications: [:mix, :phoenix, :phoenix_html, :cowboy, :logger,
                    :porcelain, :phoenix_ecto, :postgrex]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:phoenix, "~> 0.17"},
      {:phoenix_ecto, "~> 1.1"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_html, "~> 2.1"},
      {:postgrex, "~> 0.9"},
      {:cowboy, "~> 1.0"},
      {:porcelain, "~> 2.0"},
      {:exrm, "~> 0.19"}
    ]
  end
end
