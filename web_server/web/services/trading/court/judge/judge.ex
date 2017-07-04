defmodule Court.Judge do
  use GenServer

  alias Court.{Registry, Arbiter}

  # replace with actual module
  defmodule MockBuilder do
    def setup(id) do
      %{"GOOG": %{"entry": 100, "exit": 200, "id": id}}
    end
  end

  def start_link(id, builder \\ MockBuilder, registry \\ Registry) do
    name = String.to_atom("judge_" <> Integer.to_string(id))

    GenServer.start_link(__MODULE__, {id, builder, registry}, name: name)
  end

  def signals(pid) do
    GenServer.call(pid, {:signals})
  end

  def recommend(portfolio, tick_cs, registry \\ Registry) do
    {_id, pid} = registry.find(portfolio.id)
    GenServer.call(pid, {:recommend, tick_cs, Arbiter})
  end

  def recommend_by_pid(pid, tick_cs, arbiter \\ Arbiter) do
    GenServer.call(pid, {:recommend, tick_cs, arbiter})
  end

  #  Callbacks

  def init({id, builder, registry}) do
    signals = builder.setup(id)

    registry.add(id, self())

    {:ok, signals}
  end

  def handle_call({:signals}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:recommend, tick_cs, arbiter}, _from, state) do
    decision = arbiter.decide(state, tick_cs)
    {:reply, decision, state}
  end
end
