defmodule WebServer.AssetRepoTest do
  use WebServer.ModelCase

  alias WebServer.{AssetRepo, Repo, Asset, AssetTrack}

  test "all_active_tickers for portfolio" do
    {:ok, asset_1} = Repo.insert Asset.changeset(%Asset{ticker: "asset_1", name: "1"}, %{})
    {:ok, asset_2} = Repo.insert Asset.changeset(%Asset{ticker: "asset_2", name: "2"}, %{})

    Repo.insert! AssetTrack.changeset(%AssetTrack{portfolio_id: 1, asset_id: asset_1.id, active: false}, %{})
    Repo.insert! AssetTrack.changeset(%AssetTrack{portfolio_id: 1, asset_id: asset_1.id, active: true}, %{})
    Repo.insert! AssetTrack.changeset(%AssetTrack{portfolio_id: 2, asset_id: asset_2.id, active: true}, %{})

    result = AssetRepo.all_active_assets(1)

    assert result == [asset_1]
  end
end
