import Config

config :tailwind,
  version: "4.1.0",
  elemental: [
    args: ~w(
      --input=assets/css/elemental.css
      --output=priv/static/assets/elemental.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

config :esbuild,
  version: "0.25.0",
  elemental: [
    args: ~w(
      assets/js/hooks/index.js
      --bundle
      --sourcemap=inline
      --outdir=priv/static/assets/hooks
    ),
    cd: Path.expand("..", __DIR__)
  ]
