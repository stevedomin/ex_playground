defmodule ExPlayground.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_playground,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: ["lib", "web"],
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
     applications: [:phoenix, :cowboy, :logger, :porcelain]]
  end

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:phoenix, "~> 0.13.1"},
      {:phoenix_live_reload, "~> 0.4.0"},
      {:phoenix_html, "~> 1.0"},
      {:cowboy, "~> 1.0"},
      {:porcelain, "~> 2.0"},
    ]
  end
end
