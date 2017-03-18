defmodule TraderTest do
  use ExUnit.Case, async: true

  alias WebServer.{Tick, Trader}

  defmodule Broker do
    def buy_stock(_changeset) do
      "buy"
    end

    def sell_stock(_changeset) do
      "sell"
    end
  end

  test "buys stock" do
    changeset = Tick.changeset(%Tick{
      asset_id:  1,
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    })
    result = Trader.trade(changeset, Broker, 1)

    assert "buy" == result
  end

  test "sells stock" do
    changeset = Tick.changeset(%Tick{
      asset_id:  1,
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    })
    result = Trader.trade(changeset, Broker, 2)

    assert "sell" == result
  end
end
