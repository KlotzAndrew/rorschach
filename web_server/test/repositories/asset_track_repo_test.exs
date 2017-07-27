defmodule WebServer.AssetTrackRepoTest do
  use WebServer.ModelCase

  alias WebServer.{AssetTrackRepo, Portfolio, Repo, Asset, AssetTrack}

  test "toggle creates and updates on/off" do
    portfolio = %Portfolio{id: 1}
    asset = %Asset{id: 2}

    AssetTrackRepo.toggle(true, portfolio.id, asset.id)
    at = Repo.one(AssetTrack)
    assert at.active == true

    AssetTrackRepo.toggle(false, portfolio.id, asset.id)
    at = Repo.one(AssetTrack)
    assert at.active == false

    AssetTrackRepo.toggle(true, portfolio.id, asset.id)
    at = Repo.one(AssetTrack)
    assert at.active == true
  end
end
