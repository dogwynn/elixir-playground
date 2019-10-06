defmodule Pg.MixProject do
  use Mix.Project

  def project do
    [
      app: :playground,
      version: "0.1.0",
      elixir: "~> 1.9",
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:httpotion, "~> 3.1.0"},
      {:csv, "~> 2.3"},
      {:nimble_csv, "~> 0.3"},
      {:earmark, "~> 1.4.1" },
      {:floki, "~> 0.23.0"},
      {:fuzzyurl, "~> 0.9.0"},
      {:jason, "~> 1.1"},
      {:date_time_parser, "~> 0.2.0"},
      {:castore, "~> 0.1.0"},
      {:mint, "~> 0.4.0"},
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.5"},
      {:poison, "~> 3.1"},
    ]
  end

end
