# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :ex_playground, ExPlayground.Endpoint,
  url: [host: "localhost"],
  root: Path.expand("..", __DIR__),
  secret_key_base: "cAlMV+7yob3AUAxVzk4bHfT30QPggDJbFjdR4mJTWAjv2zCzCrkGFelMBJzizpQO",
  debug_errors: false,
  cache_static_manifest: "priv/static/manifest.json",
  pubsub: [name: ExPlayground.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ex_playground, :code_runner,
  timeout: 5_000

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
