defmodule ElementalStorybook.MixProject do
  use Mix.Project

  def project do
    [
      app: :elemental_storybook,
      deps: deps(),
      aliases: aliases(),
      version: "0.1.0",
      elixir: "~> 1.17",
      elixirc_paths: ~w(lib),
      start_permanent: Mix.env() == :prod
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
      # {:elemental, "~> 0.1"}
      {:elemental, path: "../"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": [
        "tailwind storybook",
        "esbuild storybook",
        "tailwind elemental_storybook",
        "esbuild elemental_storybook"
      ],
      "assets.deploy": [
        "tailwind storybook --minify",
        "esbuild storybook --minify",
        "tailwind elemental_storybook --minify",
        "esbuild elemental_storybook --minify",
        "phx.digest"
      ]
    ]
  end
end
