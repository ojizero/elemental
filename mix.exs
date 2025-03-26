defmodule Elemental.MixProject do
  use Mix.Project

  def project do
    [
      app: :elemental,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:phoenix, "~> 1.7.14"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_view, "~> 1.0"},
      {:phoenix_playground, "~> 0.1.6"},
      {:phoenix_html_helpers, "~> 1.0"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev}

      # Revisit those
      # {:bandit, "~> 1.5"},
      # {:phoenix_storybook, "~> 0.8"}
      # {:phoenix_live_reload, "~> 1.2", only: :dev},
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind elemental", "esbuild elemental"],
      "assets.deploy": [
        "tailwind elemental --minify",
        "esbuild elemental --minify",
        "phx.digest"
      ]
    ]
  end
end
