import Config

config :tailwind,
  version: "4.1.0",
  elemental: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

config :esbuild,
  version: "0.18.6",
  storybook: [
    args: ~w(
      assets/js/storybook.js
      --bundle
      --sourcemap=inline
      --outdir=priv/static/assets
    ),
    cd: Path.expand("..", __DIR__)
  ]

config :elemental, Storybook,
  compilation_mode: :lazy,
  compilation_debug: true

config :elemental, Elemental.Storybook.Endpoint,
  render_errors: [html: PhoenixPlayground.ErrorView]
