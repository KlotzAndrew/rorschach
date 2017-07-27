defmodule WebServer.AssetTrackRepo do
  import Ecto.Query
  alias WebServer.{AssetTrack, Repo}

  def toggle(active, portfolio_id, asset_id) do
    find_asset_track(portfolio_id, asset_id)
      |> upsert(portfolio_id, asset_id, active)
  end

  def find_asset_track(portfolio_id, asset_id) do
    query = from a in AssetTrack,
      where: a.portfolio_id == ^portfolio_id and a.asset_id == ^asset_id
    Repo.one(query)
  end

  defp upsert(nil, portfolio_id, asset_id, active) do
    AssetTrack.changeset(%AssetTrack{}, %{
      portfolio_id: portfolio_id,
      asset_id:     asset_id,
      active:       active
    })
      |> Repo.insert!
  end

  defp upsert(at, _portfolio, _asset, active) do
    AssetTrack.changeset(at, %{active: active})
      |> Repo.update!
  end
end
