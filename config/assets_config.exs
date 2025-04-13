import Config

config :tailwind,
  version: "4.1.0",
  elemental: [
    args: ~w(
      --input=assets/css/elemental.css
      --output=priv/static/assets/elemental.css
    ),
    cd: Path.expand("../apps/elemental", __DIR__)
  ],
  storybook: [
    args: ~w(
      --input=assets/css/storybook.css
      --output=priv/static/assets/storybook.css
    ),
    cd: Path.expand("../apps/elemental_storybook", __DIR__)
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
    cd: Path.expand("../apps/elemental", __DIR__)
  ],
  storybook: [
    args: ~w(
      assets/js/storybook.js
      --bundle
      --sourcemap=inline
      --outdir=priv/static/assets
    ),
    cd: Path.expand("../apps/elemental_storybook", __DIR__)
  ]
