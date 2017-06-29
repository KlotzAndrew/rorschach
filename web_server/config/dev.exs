use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :web_server, WebServer.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []


# Watch static and templates for browser reloading.
config :web_server, WebServer.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, format: "[$level] $message\n",
  backends: [
    {LoggerFileBackend, :error_log},
    {LoggerFileBackend, :info_log},
    {LoggerFileBackend, :warn_log},
    {LoggerFileBackend, :debug_log},
  ]

config :logger, :error_log,
  path: "log/error.log",
  level: :error

config :logger, :info_log,
  path: "log/info.log",
  level: :info

config :logger, :warn_log,
  path: "log/warn.log",
  level: :warn

config :logger, :debug_log,
  path: "log/debug.log",
  level: :debug

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :web_server, WebServer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "web_server_dev",
  hostname: System.get_env("DB_HOST") || "db",
  pool_size: 10
