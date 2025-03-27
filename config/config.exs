import Config

config :esbuild,
  version: "0.17.11",
  elemental: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.4.3",
  elemental: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :elemental, Storybook,
  compilation_mode: :lazy,
  compilation_debug: true

config :elemental, Elemental.Storybook.Endpoint,
  render_errors: [html: PhoenixPlayground.ErrorView]
