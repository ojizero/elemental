#!/usr/bin/env mix run

PhoenixPlayground.start(
  plug: Elemental.Storybook.Router,
  endpoint_options: [
    http: [ip: {127, 0, 0, 1}, port: 3000],
    secret_key_base: "90x6U5M7bXilO09bm0F0kwlcc8kpxuBT934T88seEd2FAJIaoOdSyeqBWZKtcD2d",
    watchers: [
      tailwind: {Tailwind, :install_and_run, [:storybook, ~w(--watch)]},
      esbuild: {Esbuild, :install_and_run, [:storybook, ~w(--watch)]}
    ],
    code_reloader: true,
    reloadable_compilers: [:phoenix, :elixir, :surface],
    live_reload: [
      web_console_logger: true,
      patterns: [
        ~r"lib/elemental/.*(ex|heex)$",
        ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$"
      ]
    ]
  ]
)
