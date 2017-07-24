defmodule WebServer.TickHandler do
  alias WebServer.{AtClient, Trader, Broadcaster}

  def parse(chunk, trader \\ Trader, broadcaster \\ Broadcaster) do
    tick_strings = String.split(chunk, "\n", trim: true)
    Enum.each tick_strings, fn string -> parse_tick(string, trader, broadcaster) end
  end

  defp parse_tick(string, trader, broadcaster) do
    tick_values = String.split(string, ",")
    if Enum.at(tick_values, 0) == "Q" do
      changeset = AtClient.build_tick(tick_values)

      trade_and_broadcast(trader, broadcaster, changeset)
    end
  end

  defp trade_and_broadcast(trader, broadcaster, changeset) do
    trades = trader.trade(changeset)

    broadcaster.broadcast_trades(trades)
    broadcaster.broadcast_tick(changeset.data)
  end
end
