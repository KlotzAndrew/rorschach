defmodule WebServer.Trader do
  alias WebServer.{Broker, Portfolio, Random, Repo, Noop, TickStore, LastTick}

  def trade(tick_cs, broker \\ Broker, repo \\ Repo) do
    portfolios = repo.all(Portfolio)
    Enum.reduce(portfolios, [], fn(p, acc) ->
      trade = portfolio_trade(tick_cs, p, broker)
      if trade, do: acc ++ [trade], else: acc
    end)
  end

  defp portfolio_trade(tick_cs, portfolio, broker) do
    strategy       = strategy(portfolio.trade_strategy)
    recomendations = strategy.calculate_trade(portfolio, tick_cs, TickStore)
    perform_trade(recomendations, tick_cs, portfolio, broker)
  end

  defp perform_trade({:buy, _quantity}, tick_cs, portfolio, broker) do
    broker.buy_stock(tick_cs, portfolio.id)
  end

  defp perform_trade({:sell, _quantity}, tick_cs, portfolio, broker) do
    broker.sell_stock(tick_cs, portfolio.id)
  end

  defp perform_trade(nil, _changeset, _portfolio, _broker) do
    nil
  end

  defp strategy("random"), do: Random
  defp strategy("last_tick"), do: LastTick
  defp strategy(_), do: Noop
end
