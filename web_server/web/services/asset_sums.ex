defmodule WebServer.AssetSums do
  import Ecto.Query
  alias WebServer.{Repo, Trade}

  def totals(portfolio_id, repo \\ Repo) do
    query = from t in Trade,
            where: t.portfolio_id == ^portfolio_id,
            group_by: t.to_asset_id,
            select: {t.to_asset_id, sum(t.quantity)}

    Repo.all(query)
  end
end
