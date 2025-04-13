import Config

config :elemental_storybook,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :elemental_storybook, ElementalStorybookWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ElementalStorybookWeb.ErrorHTML, json: ElementalStorybookWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ElementalStorybook.PubSub,
  live_view: [signing_salt: "UwlmdZcr"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :elemental, Storybook,
  compilation_mode: :lazy,
  compilation_debug: true

import_config "assets_config.exs"

if config_env() in ~w(dev prod)a,
  do: import_config("#{config_env()}.exs")
