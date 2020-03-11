import Config

# Configure your database
config :covid, Covid.Repo,
  username: "postgres",
  password: "postgres",
  database: "covid_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can ecovidle the server option below.
config :covid, CovidWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
