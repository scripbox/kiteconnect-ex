# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :kite_connect_ex,
  api_key: "api-key",
  api_secret: "api-secret",
  request_options: [
    timeout: 5_000,
    recv_timeout: 5_000
  ]
