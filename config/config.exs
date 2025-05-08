import Config

apps_dir = Path.expand("../apps", __DIR__)
storybook_dir = Path.expand("../apps/elemental_storybook", __DIR__)

config :tailwind,
  version: "4.1.0",
  storybook: [
    args: ~w(
      --input=assets/css/storybook.css
      --output=priv/static/assets/storybook.css
    ),
    cd: storybook_dir,
    env: %{"NODE_PATH" => apps_dir}
  ]

config :esbuild,
  version: "0.25.0",
  storybook: [
    args: ~w(
      assets/js/storybook.js
      --bundle
      --sourcemap=inline
      --outdir=priv/static/assets
    ),
    cd: storybook_dir,
    env: %{"NODE_PATH" => apps_dir}
  ]

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

if config_env() in ~w(dev prod)a,
  do: import_config("#{config_env()}.exs")
