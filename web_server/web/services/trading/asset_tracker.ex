defmodule WebServer.AssetTracker do
  alias WebServer.{AssetFetcher, Broadcaster, MarketConsumer, PortfolioRepository}
  alias Court.{Judge}

  def start_tracking(ticker) do
    asset = AssetFetcher.get_by_ticker(ticker)
    MarketConsumer.update_stream

    update_signals()

    asset
  end

  # TODO: this can be done without hitting the db
  defp update_signals do
    portfolios = PortfolioRepository.all
    Enum.each(portfolios, fn(p) ->
      signals = Judge.recalculate_signals(p)
      Broadcaster.broadcast_trade_signals(signals)
    end)
  end
end
