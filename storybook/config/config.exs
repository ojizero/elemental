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

config :tailwind,
  version: "4.1.0",
  elemental_storybook: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ],
  storybook: [
    args: ~w(
      --input=assets/css/storybook.css
      --output=priv/static/assets/storybook.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

config :esbuild,
  version: "0.25.0",
  elemental_storybook: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ],
  storybook: [
    args: ~w(
      assets/js/storybook.js
      --bundle
      --sourcemap=inline
      --outdir=priv/static/assets
    ),
    cd: Path.expand("..", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :elemental, Storybook,
  compilation_mode: :lazy,
  compilation_debug: true

import_config "#{config_env()}.exs"
