defmodule BorkBorkBork.MixProject do
  use Mix.Project

  def project do
    [
      app: :bork_bork_bork,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
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
      {:nimble_parsec, "~> 1.2"},
      {:yaml_elixir, "~> 2.9"}
    ]
  end
end
