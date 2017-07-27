defmodule WebServer.AssetTrackRepo do
  import Ecto.Query
  alias WebServer.{AssetTrack, Repo}

  def add_to_portfolio(portfolio, asset) do
    find_asset_track(portfolio, asset)
      |> upsert(portfolio, asset, true)
  end

  def remove_from_portfolio(portfolio, asset) do
    find_asset_track(portfolio, asset)
      |> upsert(portfolio, asset, false)
  end

  def find_asset_track(portfolio, asset) do
    query = from a in AssetTrack,
      where: a.portfolio_id == ^portfolio.id and a.asset_id == ^asset.id
    Repo.one(query)
  end

  defp upsert(nil, portfolio, asset, active) do
    AssetTrack.changeset(%AssetTrack{}, %{
      portfolio_id: portfolio.id,
      asset_id: asset.id,
      active: active
    })
      |> Repo.insert!
  end

  defp upsert(at, _portfolio, _asset, active) do
    AssetTrack.changeset(at, %{active: active})
      |> Repo.update!
  end
end
