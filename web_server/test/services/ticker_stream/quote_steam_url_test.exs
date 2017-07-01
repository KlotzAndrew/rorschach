defmodule QuoteStreamUrlTest do
  # use ExUnit.Case, async: true
  use WebServer.ModelCase, async: false

  alias WebServer.{Asset, Repo, QuoteStreamUrl}

  defmodule Client do
    def streaming_url(arr), do: "some_url_" <> Enum.join(arr, "")
  end

  test "parses stream chunk" do
    ticker       = "TSLA"
    expected_url = "some_url_#{ticker}"

    # Repo.insert! AssetTrack.changeset(%AssetTrack{}, %{portfolio_id: 1, asset_id: 1, active: true})
    Repo.insert! Asset.changeset(%Asset{}, %{id: 1, ticker: ticker, name: "cool name"})

    result = QuoteStreamUrl.url(Client)

    assert expected_url == result
  end
end
