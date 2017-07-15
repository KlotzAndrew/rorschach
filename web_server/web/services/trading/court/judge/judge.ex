defmodule Court.Judge do
  use GenServer

  alias Court.{Registry, Arbiter, Signals}

  def start_link(id, signals \\ Signals, registry \\ Registry) do
    name = String.to_atom("judge_" <> Integer.to_string(id))

    GenServer.start_link(__MODULE__, {id, signals, registry}, name: name)
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

  def init({id, signals, registry}) do
    signals = signals.calculate(id)

    registry.add(id, self())

    {:ok, signals}
  end

  def handle_call({:signals}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:recommend, tick_cs, arbiter}, _from, state) do
    decision = arbiter.decide(state["signals"], tick_cs)
    {:reply, decision, state}
  end
end
