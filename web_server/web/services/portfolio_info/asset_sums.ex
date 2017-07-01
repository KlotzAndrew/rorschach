defmodule WebServer.AssetSums do
  import Ecto.Query
  alias WebServer.{Repo, Trade}

  def stocks(portfolio_id, repo \\ Repo) do
    query = from t in Trade,
            where: t.portfolio_id == ^portfolio_id and t.type == "Buy" or t.type == "Sell",
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
