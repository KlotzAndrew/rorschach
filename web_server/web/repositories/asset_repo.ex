defmodule WebServer.AssetRepo do
  import Ecto.Query
  alias WebServer.{Asset, AssetTrack, Repo}

  def all_non_cash do
    query =
      from a in Asset,
      where: a.ticker != "CASH:USD"

    Repo.all(query)
  end

  def all_stock_tickers do
    query =
      from a in Asset,
      where: a.ticker != "CASH:USD",
      select: a.ticker

    Repo.all(query)
  end

  def all_active_tickers do
    query =
      from a in Asset,
      where: a.ticker != "CASH:USD",
      join: at in AssetTrack, on: at.asset_id == a.id,
      where: at.active == true,
      distinct: true,
      select: a.ticker

    Repo.all(query)
  end

  def all_active_assets(portfolio_id) do
    query =
      from a in Asset,
      where: a.ticker != "CASH:USD",
      join: at in AssetTrack, on: at.asset_id == a.id,
      where: at.active == true,
      where: at.portfolio_id == ^portfolio_id,
      distinct: true,
      select: a

    Repo.all(query)
  end
end
