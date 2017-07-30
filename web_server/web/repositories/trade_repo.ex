defmodule WebServer.TradeRepo do
  import Ecto.Query
  alias WebServer.{Repo, Trade}

  def trades_for_portfolio(portfolio_id, repo \\ Repo) do
    query = from t in Trade,
              where: t.portfolio_id == ^portfolio_id,
              select: t

    repo.all(query)
  end

  def stocks(portfolio_id, repo \\ Repo) do
    query = from t in Trade,
            where: t.portfolio_id == ^portfolio_id and not is_nil(t.asset_id),
            group_by: t.asset_id,
            select: {t.asset_id, sum(t.quantity)}

    repo.all(query)
  end

  def cash(portfolio_id, repo \\ Repo) do
    query = from t in Trade,
            where: t.portfolio_id == ^portfolio_id,
            group_by: t.cash_id,
            select: {t.cash_id, sum(t.cash_total)}

    repo.all(query)
  end
end
