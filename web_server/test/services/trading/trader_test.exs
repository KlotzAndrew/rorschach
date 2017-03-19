defmodule TraderTest do
  use ExUnit.Case, async: true

  alias WebServer.{Tick, Trader}

  defmodule Broker do
    def buy_stock(_changeset, 88) do
      "buy"
    end

    def sell_stock(_changeset, 88) do
      "sell"
    end
  end

  defmodule Repo do
    def all(_) do
      [%{id: 88}]
    end
  end

  test "buys stock" do
    changeset = Tick.changeset(%Tick{
      asset_id:  1,
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    })
    result = Trader.trade(changeset, Broker, Repo, 1)

    assert ["buy"] == result
  end

  test "sells stock" do
    changeset = Tick.changeset(%Tick{
      asset_id:  1,
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    })
    result = Trader.trade(changeset, Broker, Repo, 2)

    assert ["sell"]== result
  end

  test "no trade" do
    changeset = Tick.changeset(%Tick{
      asset_id:  1,
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    })
    result = Trader.trade(changeset, Broker, Repo, 4)

    assert [] == result
  end
end
