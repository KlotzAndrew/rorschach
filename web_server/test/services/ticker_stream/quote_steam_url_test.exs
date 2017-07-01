defmodule QuoteStreamUrlTest do
  # use ExUnit.Case, async: true
  use WebServer.ModelCase, async: false

  alias WebServer.{Asset, Repo, QuoteStreamUrl}

  test "parses stream chunk" do
    ticker       = "TSLA"
    expected_url = "http://market_mock:5020/quoteStream?symbol=#{ticker}"

    # Repo.insert! AssetTrack.changeset(%AssetTrack{}, %{portfolio_id: 1, asset_id: 1, active: true})
    Repo.insert! Asset.changeset(%Asset{}, %{id: 1, ticker: ticker, name: "cool name"})

    result = QuoteStreamUrl.url

    assert expected_url == result
  end
end
