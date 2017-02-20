defmodule WebServer.AssetTrackView do
  use WebServer.Web, :view

  def render("index.json", %{asset_tracks: asset_tracks}) do
    %{data: render_many(asset_tracks, WebServer.AssetTrackView, "asset_track.json")}
  end

  def render("show.json", %{asset_track: asset_track}) do
    %{data: render_one(asset_track, WebServer.AssetTrackView, "asset_track.json")}
  end

  def render("asset_track.json", %{asset_track: asset_track}) do
    %{id: asset_track.id,
      portfolio_id: asset_track.portfolio_id,
      asset_id: asset_track.asset_id}
  end
end
