defmodule WebServer.Trader do
  alias WebServer.{Broker, Portfolio, Repo}
  alias Court.{Judge}

  def trade(tick, broker \\ Broker, repo \\ Repo, judge \\ Judge) do
    portfolios = repo.all(Portfolio)
    Enum.reduce(portfolios, [], fn(p, acc) ->
      trade = portfolio_trade(tick, p, broker, judge)
      if trade, do: acc ++ [trade], else: acc
    end)
  end

  defp portfolio_trade(tick, portfolio, broker, judge) do
    recomendations = judge.recommend(portfolio, tick)
    perform_trade(recomendations, tick, portfolio, broker)
  end

  defp perform_trade({:buy, _quantity}, tick, portfolio, broker) do
    broker.buy_stock(tick, portfolio.id)
  end

  defp perform_trade({:sell, _quantity}, tick, portfolio, broker) do
    broker.sell_stock(tick, portfolio.id)
  end

  defp perform_trade(nil, _changeset, _portfolio, _broker) do
    nil
  end
end
