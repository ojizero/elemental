import Config

config :tailwind,
  version: "4.1.0",
  storybook: [
    args: ~w(
      --input=assets/css/storybook.css
      --output=priv/static/assets/storybook.css
    ),
    cd: Path.expand("..", __DIR__)
  ],
  release: [
    args: ~w(
      --minify
      --input=assets/css/elemental.css
      --output=priv/static/assets/elemental.css
    ),
    cd: Path.expand("..", __DIR__)
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
    cd: Path.expand("..", __DIR__)
  ],
  release: [
    args: ~w(
      assets/js/hooks/index.js
      --bundle
      --sourcemap=inline
      --outdir=priv/static/assets/hooks
    ),
    cd: Path.expand("..", __DIR__)
  ]

config :elemental, Storybook,
  compilation_mode: :lazy,
  compilation_debug: true

config :elemental, Elemental.Storybook.Endpoint,
  render_errors: [html: PhoenixPlayground.ErrorView]
