defmodule Elemental.MixProject do
  use Mix.Project

  def project do
    [
      app: :elemental,
      version: "0.1.0",
      elixir: "~> 1.17",
      description: "A Tailwind and DaisyUI based Phoenix components library.",
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      aliases: aliases(),
      package: package()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "storybook/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [extra_applications: [:logger]]
  end

  defp package do
    %{
      name: :elemental,
      licenses: ["MIT"],
      files: ~w(mix.exs package.json lib priv LICENCE README.md),
      links: %{"GitHub" => "https://github.com/ojizero/elemental"}
    }
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:esbuild, "~> 0.9", runtime: Mix.env() == :dev, only: [:dev, :test]},
      {:tailwind, "~> 0.3", runtime: Mix.env() == :dev, only: [:dev, :test]},
      {:phoenix, "~> 1.7.14", only: [:dev, :test]},
      {:phoenix_html, "~> 4.1", only: [:dev, :test]},
      {:phoenix_live_view, "~> 1.0", only: [:dev, :test]},
      {:phoenix_storybook, "~> 0.8", only: [:dev, :test]},
      {:phoenix_playground, "~> 0.1.6", only: [:dev, :test]},
      {:phoenix_html_helpers, "~> 1.0", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      "dev.setup": ["deps.get", "assets.setup", "assets.storybook"],
      "rel.setup": ["deps.get", "assets.setup", "assets.release"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.release": ["tailwind release", "esbuild release"],
      "assets.storybook": ["tailwind storybook", "esbuild storybook"],
      storybook: ["run storybook.exs"],
      release: ["rel.setup", "hex.publish"]
    ]
  end
end
