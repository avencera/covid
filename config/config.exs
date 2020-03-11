import Config

config :covid,
  ecto_repos: [Covid.Repo]

config :covid, CovidWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "c2IBEdf4jM0ebvy0i9H+AxxV9lkH1P4hQtiVLmWE2Ozl678hHQb+3XYGq//3sU6S",
  render_errors: [view: CovidWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Covid.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "ZGnTqFRaNVjW+8sJvyYBgMl8X5sltZ9+mRRgSuEQiwe/GXuBZ/comMIllU/2yjMQ"
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
