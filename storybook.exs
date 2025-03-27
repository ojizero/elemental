#!/usr/bin/env mix run

PhoenixPlayground.start(
  plug: Elemental.Storybook.Router,
  endpoint_options: [
    http: [ip: {127, 0, 0, 1}, port: 3000],
    secret_key_base: "90x6U5M7bXilO09bm0F0kwlcc8kpxuBT934T88seEd2FAJIaoOdSyeqBWZKtcD2d"
  ]
)
