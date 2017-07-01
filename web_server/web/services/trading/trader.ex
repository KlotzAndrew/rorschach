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
    strategy       = trade_strategy(portfolio)
    recomendations = strategy.calculate_trade(portfolio, changeset, TickStore)
    perform_trade(changeset, portfolio, broker, recomendations)
  end

  defp perform_trade(changeset, portfolio, broker, recomendations) do
    case recomendations do
        {:buy, _quantity} -> broker.buy_stock(changeset, portfolio.id)
        {:sell, _quantity} -> broker.sell_stock(changeset, portfolio.id)
        _ -> nil
    end
  end

  defp trade_strategy(portfolio) do
    case portfolio.trade_strategy do
      "random" -> Random
      "last_tick" -> LastTick
      _ -> Noop
    end
  end
end
