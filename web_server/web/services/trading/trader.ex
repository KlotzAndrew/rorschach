defmodule WebServer.Trader do
  alias WebServer.{Broker, Portfolio, Random, Repo, Noop}

  def trade(changeset, broker \\ Broker, repo \\ Repo, roll \\ nil) do
    portfolios = repo.all(Portfolio)
    Enum.reduce(portfolios, [], fn(p, acc) ->
      roll = if roll == nil, do: :rand.uniform(4), else: roll
      trade = portfolio_trade(changeset, p, broker, roll)
      if trade, do: acc ++ [trade], else: acc
    end)
  end

  defp portfolio_trade(changeset, portfolio, broker, roll) do
    strategy       = trade_strategy(portfolio)
    recomendations = strategy.calculate_trade(roll)
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
      _ -> Noop
    end
  end
end
