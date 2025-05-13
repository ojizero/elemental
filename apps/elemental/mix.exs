defmodule Elemental.MixProject do
  use Mix.Project

  def project do
    [
      app: :elemental,
      version: "0.3.1",
      elixir: "~> 1.17",
      description: "A Tailwind and DaisyUI based Phoenix components library.",
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      aliases: aliases(),
      package: package(),
      # Umbrella configs
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      build_path: "../../_build",
      config_path: "../../config/config.exs"
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [extra_applications: [:logger]]
  end

  defp package do
    %{
      name: :elemental,
      files: ~w(mix.exs package.json lib ../../LICENCE ../../README.md),
      links: %{"GitHub" => "https://github.com/ojizero/elemental"},
      licenses: ["MIT"]
    }
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:esbuild, "~> 0.9", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.3", runtime: Mix.env() == :dev},
      {:phoenix, "~> 1.7.14"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_view, "~> 1.0"},
      {:phoenix_html_helpers, "~> 1.0"}
    ]
  end

  defp aliases do
    []
  end
end
