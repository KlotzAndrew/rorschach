defmodule WebServer.LastTick do
  alias WebServer.{TickStore}

  def calculate_trade(_portfolio, changeset, store \\ TickStore) do
    ticks = store.get(changeset)
    last_tick = List.last(ticks)

    if last_tick do
      case changeset.data.ask_price > last_tick.data.ask_price do
        true -> {:sell, -1}
        false -> {:buy, 1}
      end
    else
      nil
    end
  end
end
