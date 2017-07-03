defmodule Court.JudgeSupervisor do
  use Supervisor

  @name Court.JudgeSupervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_judge(id) do
    Supervisor.start_child(@name, [id])
  end

  def init(_arg) do
    children = [
      worker(Court.Judge, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
