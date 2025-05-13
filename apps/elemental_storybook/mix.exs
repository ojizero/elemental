defmodule ElementalStorybook.MixProject do
  use Mix.Project

  def project do
    [
      app: :elemental_storybook,
      deps: deps(),
      aliases: aliases(),
      version: "0.3.1",
      elixir: "~> 1.17",
      elixirc_paths: ~w(lib),
      start_permanent: Mix.env() == :prod,
      # Umbrella configs
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      build_path: "../../_build",
      config_path: "../../config/config.exs"
    ]
  end

  def application do
    [
      mod: {ElementalStorybook.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.2"},
      {:bandit, "~> 1.5"},
      {:phoenix, "~> 1.7.21"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_view, "~> 1.0"},
      {:phoenix_storybook, "~> 0.8"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:esbuild, "~> 0.9", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.3", runtime: Mix.env() == :dev},
      {:elemental, in_umbrella: true}
    ]
  end

  defp aliases do
    [
      "assets.build": ["tailwind storybook", "esbuild storybook"],
      "assets.deploy": [
        "tailwind storybook --minify",
        "esbuild storybook --minify",
        "phx.digest"
      ]
    ]
  end
end
