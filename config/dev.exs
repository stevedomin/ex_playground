use Mix.Config

config :ex_playground, ExPlayground.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  watchers: [{Path.expand("node_modules/brunch/bin/brunch"), ["watch"]}]

# Watch static and templates for browser reloading.
config :ex_playground, ExPlayground.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"
