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

# kafka setup
config :kafka_ex,
  # a list of brokers to connect to in {"HOST", port} format
  brokers: [
    {System.get_env("KAFKA_HOST") || "kafka", 9092},
  ],
  # the default consumer group for worker processes, must be a binary (string)
  #    NOTE if you are on Kafka < 0.8.2 or if you want to disable the use of
  #    consumer groups, set this to :no_consumer_group (this is the
  #    only exception to the requirement that this value be a binary)
  consumer_group: :no_consumer_group,
  # Set this value to true if you do not want the default
  # `KafkaEx.Server` worker to start during application start-up -
  # i.e., if you want to start your own set of named workers
  disable_default_worker: false,
  # Timeout value, in msec, for synchronous operations (e.g., network calls).
  # If this value is greater than GenServer's default timeout of 5000, it will also
  # be used as the timeout for work dispatched via KafkaEx.Server.call (e.g., KafkaEx.metadata).
  # In those cases, it should be considered a 'total timeout', encompassing both network calls and
  # wait time for the genservers.
  sync_timeout: 3000,
  # Supervision max_restarts - the maximum amount of restarts allowed in a time frame
  max_restarts: 10,
  # Supervision max_seconds -  the time frame in which :max_restarts applies
  max_seconds: 60,
  # This is the flag that enables use of ssl
  use_ssl: false,
  # see SSL OPTION DESCRIPTIONS - CLIENT SIDE at http://erlang.org/doc/man/ssl.html
  # for supported options
  # ssl_options: [
  #   cacertfile: System.cwd <> "/ssl/ca-cert",
  #   certfile: System.cwd <> "/ssl/cert.pem",
  #   keyfile: System.cwd <> "/ssl/key.pem",
  # ],
  # set this to the version of the kafka broker that you are using
  # include only major.minor.patch versions.  must be at least 0.8.0
  kafka_version: "0.9.0"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
