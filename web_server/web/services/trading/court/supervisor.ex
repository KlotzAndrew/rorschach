defmodule Court.Supervisor do
  use Supervisor

  # A simple module attribute that stores the supervisor name
  @name Court.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_bucket do
    Supervisor.start_child(@name, [])
  end

  def init(:ok) do
    children = [
      worker(Court.Registry, []),
      supervisor(Court.JudgeSupervisor, []),
    ]

    supervise(children, strategy: :one_for_all)
  end
end
