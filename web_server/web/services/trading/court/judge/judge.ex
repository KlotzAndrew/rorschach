defmodule Court.Judge do
  use GenServer

  alias Court.{Registry, Arbiter, Signals}

  def start_link(id, signals \\ Signals, registry \\ Registry) do
    judge_id = id_to_int(id)
    name = judge_name(judge_id)

    GenServer.start_link(__MODULE__, {judge_id, signals, registry}, name: name)
  end

  def signals(pid) do
    GenServer.call(pid, {:signals})
  end

  def recommend(portfolio, tick, registry \\ Registry) do
    {_id, pid} = registry.find(portfolio.id)
    GenServer.call(pid, {:recommend, tick, Arbiter})
  end

  def recommend_by_pid(pid, tick, arbiter \\ Arbiter) do
    GenServer.call(pid, {:recommend, tick, arbiter})
  end

  def hear_trade(portfolio, trade, tick, registry \\ Registry, arbiter \\ Arbiter) do
    {_id, pid} = registry.find(portfolio.id)
    GenServer.call(pid, {:hear_trade, trade, tick, arbiter})
  end

  def hear_trade_by_pid(pid, trade, tick, arbiter \\ Arbiter) do
    GenServer.call(pid, {:hear_trade, trade, tick, arbiter})
  end

  def recalculate_signals(portfolio, registry \\ Registry, signals \\ Signals) do
    id         = portfolio.id
    {_id, pid} = registry.find(id)
    GenServer.call(pid, {:recalculate_signals, id, signals})
  end

  defp judge_name(id) do
    String.to_atom("judge_" <> Integer.to_string(id))
  end

  defp id_to_int(id) when is_integer(id), do: id
  defp id_to_int(id) do
    {int, _} = Integer.parse(id)
    int
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

  def handle_call({:recommend, tick, arbiter}, _from, state) do
    result = arbiter.decide(state["signals"], tick)
    new_state = Map.put(state, "signals", result[:signals])
    {:reply, result[:decision], new_state}
  end

  def handle_call({:hear_trade, trade, tick, arbiter}, _from, state) do
    new_signals = arbiter.new_trade_info(state["signals"], trade, tick)
    new_state = Map.put(state, "signals", new_signals)
    {:reply, new_state, new_state}
  end

  def handle_call({:recalculate_signals, id, signals}, _from, _state) do
    signals = signals.calculate(id)

    {:reply, signals, signals}
  end

end
