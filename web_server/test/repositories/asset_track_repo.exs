defmodule WebServer.AssetTrackRepoTest do
  use WebServer.ModelCase

  alias WebServer.{AssetTrackRepo, Portfolio, Repo, Asset, AssetTrack}

  test "toggle creates and updates on/off" do
    portfolio = %Portfolio{id: 1}
    asset = %Asset{id: 2}

    AssetTrackRepo.add_to_portfolio(portfolio, asset)
    at = Repo.one(AssetTrack)
    assert at.active == true

    AssetTrackRepo.remove_from_portfolio(portfolio, asset)
    at = Repo.one(AssetTrack)
    assert at.active == false

    AssetTrackRepo.add_to_portfolio(portfolio, asset)
    at = Repo.one(AssetTrack)
    assert at.active == true
  end
end
