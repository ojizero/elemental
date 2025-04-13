import Config

config :elemental_storybook, ElementalStorybookWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 3000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "5J/+ctsrilblskv2uEGvpcRzKhlg09yo6l96ntodPeO6dgbYQFE983vzjki5u7Wz",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:storybook, ~w(--watch)]},
    tailwind: {Tailwind, :install_and_run, [:storybook, ~w(--watch)]}
  ],
  live_reload: [
    patterns: [
      ~r"../lib/elemental/.*(ex|heex)$",
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$"
    ]
  ]

config :logger, :console, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  debug_heex_annotations: true,
  enable_expensive_runtime_checks: true
