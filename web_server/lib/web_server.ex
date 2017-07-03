defmodule WebServer do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(WebServer.Repo, []),
      # Start the endpoint when the application starts
      supervisor(WebServer.Endpoint, []),
      supervisor(KVStore.Supervisor, []),
      supervisor(Court.Supervisor, []),
      # Start your own worker by calling: WebServer.Worker.start_link(arg1, arg2, arg3)
      # worker(WebServer.Worker, [arg1, arg2, arg3]),
    ]

    children =
      case Mix.env do
        :test ->
          IO.puts "TickerStream not starting in test env..."
          children
        _ ->
          IO.puts "TickerStream starting..."
          children ++ [worker(WebServer.TickerStream, [])]
      end

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WebServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    WebServer.Endpoint.config_change(changed, removed)
    :ok
  end
end
