defmodule AssetFetcherTest do
  # use ExUnit.Case#, async: true
  use WebServer.ModelCase, async: true

  alias WebServer.AssetFetcher
  alias WebServer.Asset
  alias WebServer.Repo

  test "returns asset when present" do
    ticker = "GOOG"
    Repo.insert! Asset.changeset(%Asset{}, %{ticker: ticker, name: "cool company"})

    asset = AssetFetcher.get_by_ticker(ticker)

    assert asset.ticker == ticker
  end

  test "returns asset when not present" do
    ticker = "TSLA"

    asset = AssetFetcher.get_by_ticker(ticker)

    assert asset.ticker == ticker
    assert asset.name == "Tesla Motors, Inc."
  end
end
