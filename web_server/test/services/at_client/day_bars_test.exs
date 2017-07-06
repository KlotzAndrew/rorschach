defmodule AtClient.DarBarsTest do
  use ExUnit.Case, async: true
  use Timex

  alias AtClient.{DayBars}
  alias WebServer.{Asset, AtClient, DayBar}

  defmodule MockPoisonResponse do
    def body do
      "20170601000000,70.2,70.6,69.4,70.1,20232975\r\n"
    end
  end

  defmodule MockClient do
    def get!(_url) do
      MockPoisonResponse
    end
  end

  defmodule MockRepo do
    def insert(cs) do
      {:ok, cs.params}
    end
  end

  test "returns day for ticker" do
    days = 2
    asset = %Asset{name: "asset_1", ticker: "MSFT", id: 2}
    changeset = DayBar.changeset(%DayBar{}, %{
      asset_id: asset.id,
      at_timestamp: AtClient.datetime("20170601000000"),
      open_price: Decimal.new(70.2),
      high_price: Decimal.new(70.6),
      low_price: Decimal.new(69.4),
      close_price: Decimal.new(70.1),
      volume: "20232975"
    })

    expected = [{:ok, changeset.params}]

    assert DayBars.fetch(asset, days, MockRepo, MockClient) == expected
  end
end
