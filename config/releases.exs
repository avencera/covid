import Config

config :covid, CovidWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT", "4000"))],
  url: [host: System.fetch_env!("DOMAIN_NAME"), scheme: "https", port: 443],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
  live_view: [
    signing_salt: System.fetch_env!("LIVE_VIEW_SIGNING_SALT")
  ]

config :libcluster,
  topologies: [
    covid: [
      strategy: Elixir.Cluster.Strategy.Kubernetes.DNS,
      config: [
        service: System.get_env("SERVICE_NAME", "covid"),
        application_name: "covid",
        polling_interval: 5_000
      ]
    ]
  ]

config :covid, :releases,
  cookie: System.fetch_env!("COOKIE"),
  pod_ip: System.fetch_env!("POD_IP")
