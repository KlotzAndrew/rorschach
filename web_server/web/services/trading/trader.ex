defmodule WebServer.Trader do
  alias WebServer.{Broker, Portfolio, Random, Repo, Noop, TickStore, LastTick}

  def trade(changeset, broker \\ Broker, repo \\ Repo) do
    portfolios = repo.all(Portfolio)
    Enum.reduce(portfolios, [], fn(p, acc) ->
      trade = portfolio_trade(changeset, p, broker)
      if trade, do: acc ++ [trade], else: acc
    end)
  end

  defp portfolio_trade(changeset, portfolio, broker) do
    strategy       = strategy(portfolio.trade_strategy)
    recomendations = strategy.calculate_trade(portfolio, changeset, TickStore)
    perform_trade(recomendations, changeset, portfolio, broker)
  end

  defp perform_trade({:buy, _quantity}, changeset, portfolio, broker) do
    broker.buy_stock(changeset, portfolio.id)
  end

  defp perform_trade({:sell, _quantity}, changeset, portfolio, broker) do
    broker.sell_stock(changeset, portfolio.id)
  end

  defp perform_trade(nil, _changeset, _portfolio, _broker) do
    nil
  end

  defp strategy("random"), do: Random
  defp strategy("last_tick"), do: LastTick
  defp strategy(_), do: Noop
end
