defmodule BrokerTest do
  use ExUnit.Case, async: true

  alias WebServer.{Asset, Broker, Tick}

  defmodule Repo do
    def get_by!(_asset, ticker: ticker) do
      case ticker do
        "CASH:USD" -> %Asset{id: 1}
        "GOOG" -> %Asset{id: 2}
        _ -> ""
      end
    end

    def insert!(changeset) do
      if changeset.valid? do
        # changeset.data
        "trade_1"
      end
    end
  end

  test "buys stock" do
    changeset = Tick.changeset(%Tick{
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    })
    result = Broker.buy_stock(changeset, Repo)

    assert ["trade_1"] == result
  end

  test "sells stock" do
    changeset = Tick.changeset(%Tick{
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    })
    result = Broker.sell_stock(changeset, Repo)

    assert ["trade_1"] == result
  end
end
