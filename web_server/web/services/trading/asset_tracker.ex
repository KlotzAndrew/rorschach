defmodule WebServer.AssetTracker do
  alias WebServer.{AssetFetcher, Broadcaster, MarketConsumer, PortfolioRepository, AssetTrackRepo}
  alias Court.{Judge}

  def start_tracking(ticker) do
    asset = AssetFetcher.get_by_ticker(ticker)
    MarketConsumer.update_stream

    update_signals()

    asset
  end

  def toggle_tracking(portfolio_id, asset, active) do
    asset_track = AssetTrackRepo.toggle(active, portfolio_id, asset.id)
    refresh_all()

    asset_track
  end

  defp refresh_all do
    MarketConsumer.update_stream
    update_signals()
  end

  # TODO: this can be done without hitting the db
  defp update_signals do
    portfolios = PortfolioRepository.all
    Enum.each(portfolios, fn(p) ->
      signals = Judge.recalculate_signals(p)
      Broadcaster.broadcast_trade_signals(p, signals)
    end)
  end
end
