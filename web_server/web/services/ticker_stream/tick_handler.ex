defmodule WebServer.TickHandler do
  alias WebServer.{AtClient, Trader, Broadcaster}

  def parse(chunk, trader \\ Trader, broadcaster \\ Broadcaster) do
    tick_strings = String.split(chunk, "\n", trim: true)
    Enum.each tick_strings, fn string -> parse_tick(string, trader, broadcaster) end
  end

  defp parse_tick(string, trader, broadcaster) do
    tick_values = String.split(string, ",")
    if Enum.at(tick_values, 0) == "Q" do
      tick = AtClient.build_tick(tick_values)

      trade_and_broadcast(trader, broadcaster, tick)
    end
  end

  defp trade_and_broadcast(trader, broadcaster, tick) do
    trades = trader.trade(tick)

    broadcaster.broadcast_trades(trades)
    broadcaster.broadcast_tick(tick)
  end
end
