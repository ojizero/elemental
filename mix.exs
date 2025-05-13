defmodule ElementalUmbra.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.3.1",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      releases: releases()
    ]
  end

  defp deps do
    []
  end

  defp aliases do
    [
      storybook: ["phx.server --open"],
      setup: ["deps.get", "assets.setup", "assets.build"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"]
    ]
  end

  defp releases do
    [
      storybook: [
        applications: [elemental_storybook: :permanent],
        strip_beams: [keep: ["Docs"]]
      ]
    ]
  end
end
