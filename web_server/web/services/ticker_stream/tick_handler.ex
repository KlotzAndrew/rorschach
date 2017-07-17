defmodule WebServer.TickHandler do
  alias WebServer.{AtClient, Trader, Repo, Broadcaster, TickStore}

  def parse(chunk, repo \\ Repo, trader \\ Trader, broadcaster \\ Broadcaster, store \\ TickStore) do
    tick_strings = String.split(chunk, "\n", trim: true)
    Enum.each tick_strings, fn string -> parse_tick(string, repo, trader, broadcaster, store) end
  end

  defp parse_tick(string, repo, trader, broadcaster, store) do
    tick_values = String.split(string, ",")
    if Enum.at(tick_values, 0) == "Q" do
      changeset = AtClient.build_tick(tick_values)

      trade_and_broadcast(trader, broadcaster, changeset, store)

      save_tick(changeset, repo, broadcaster)
    end
  end

  defp trade_and_broadcast(trader, broadcaster, changeset, store) do
    store.add(changeset)

    trades = trader.trade(changeset)
    broadcaster.broadcast_trades(trades)
  end

  defp save_tick(changeset, repo, broadcaster) do
    broadcaster.broadcast_tick(changeset.data)
    repo.insert!(changeset)
  end
end
