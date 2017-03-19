defmodule WebServer.Trader do
  alias WebServer.{Broker, Portfolio, Repo}

  def trade(changeset, broker \\ Broker, repo \\ Repo, roll \\ :rand.uniform(4)) do
    portfolios = repo.all(Portfolio)
    Enum.reduce(portfolios, [], fn(p, acc) ->
      trade = portfolio_trade(changeset, p.id, broker, roll)
      if trade, do: acc ++ [trade], else: acc
    end)
  end

  defp portfolio_trade(changeset, portfolio_id, broker, roll) do
    case roll do
      1 -> broker.buy_stock(changeset, portfolio_id)
      2 -> broker.sell_stock(changeset, portfolio_id)
      _ -> nil
    end
  end
end
