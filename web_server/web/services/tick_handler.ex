defmodule WebServer.TickHandler do
  alias WebServer.{AtClient, Trader, Repo, Broadcaster}

  def parse(chunk, repo \\ Repo, trader \\ Trader, broadcaster \\ Broadcaster) do
    tick_strings = String.split(chunk, "\n", trim: true)
    Enum.each tick_strings, fn string -> parse_tick(string, repo, trader, broadcaster) end
  end

  defp parse_tick(string, repo, trader, broadcaster) do
    tick_values = String.split(string, ",")
    if Enum.at(tick_values, 0) == "Q" do
      changeset = AtClient.build_tick(tick_values)

      trades = trader.trade(changeset)
      broadcaster.broadcast_trades(trades)
      save_tick(changeset, repo)
    end
  end

  defp save_tick(changeset, repo) do
    repo.insert!(changeset)
  end
end
