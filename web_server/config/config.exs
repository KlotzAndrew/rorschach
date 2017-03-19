# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :web_server,
  ecto_repos: [WebServer.Repo]

# Configures the endpoint
config :web_server, WebServer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "e8tPNHR8vbZCL25PQuxVB+PRSEbCDcN1kTCh7IBmCTXk6na776/W+D/FawIcTqFX",
  render_errors: [view: WebServer.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WebServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :plug, :mimes, %{
  "application/vnd.api+json" => ["json-api"]
}

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
