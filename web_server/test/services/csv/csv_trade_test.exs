defmodule CSVBuilderTest do
  use ExUnit.Case, async: true

  alias WebServer.{Asset, CSVBuilder, Trade}

  defmodule MockRepo do
    def all(Asset) do
      [
        %Asset{id: 1, name: "asset_1", ticker: "A1"}
      ]
    end
  end

  defmodule MockTradeRepo do
    def trades_for_portfolio(_) do
      [
        %Trade{
          asset_id:     1,
          price:        Decimal.new("120.5"),
          quantity:     2,
          cash_id:      3,
          portfolio_id: 4,
          cash_total:   "88.88",
          type:         "Buy",
          inserted_at:  Ecto.DateTime.cast!("2017-07-30 22:02:52")
        }
      ]
    end
  end

  test "dump_trades builds csv" do
    portfolio_id = 1
    result = CSVBuilder.dump_trades(portfolio_id, MockRepo, MockTradeRepo)
    expected = "asset,quantity,price,cash_total,type,inserted_at\nasset_1,2,120.5,88.88,Buy,2017-07-30T22:02:52\n"

    assert result == expected
  end
end
