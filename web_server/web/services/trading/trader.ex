defmodule WebServer.Trader do
  alias WebServer.{Broker, Portfolio, Repo}
  alias Court.{Judge}

  def trade(tick_cs, broker \\ Broker, repo \\ Repo, judge \\ Judge) do
    portfolios = repo.all(Portfolio)
    Enum.reduce(portfolios, [], fn(p, acc) ->
      trade = portfolio_trade(tick_cs, p, broker, judge)
      notify_trade(trade, tick_cs, p, judge)
      if trade, do: acc ++ [trade], else: acc
    end)
  end

  defp portfolio_trade(tick_cs, portfolio, broker, judge) do
    recomendations = judge.recommend(portfolio, tick_cs)
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

  defp notify_trade(nil, _tick, _portfolio, _judge), do: nil
  defp notify_trade(trade, tick, portfolio, judge) do
    judge.hear_trade(portfolio, trade, tick)
  end
end
