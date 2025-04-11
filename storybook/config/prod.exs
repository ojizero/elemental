import Config

config :elemental_storybook, ElementalStorybookWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info
