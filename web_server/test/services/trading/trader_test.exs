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
    def all(_), do: [%{id: 88, trade_strategy: nil}]
  end

  defmodule RepoRandom do
    def all(_), do: [%{id: 88, trade_strategy: "random"}]
  end
@tag :wip
  test "buys stock" do
    changeset = Tick.changeset(%Tick{
      asset_id:  1,
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    })
    result = Trader.trade(changeset, Broker, RepoRandom, 1)

    assert ["buy"] == result
  end

  test "sells stock" do
    changeset = Tick.changeset(%Tick{
      asset_id:  1,
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    })
    result = Trader.trade(changeset, Broker, RepoRandom, 2)

    assert ["sell"]== result
  end

  test "no trade" do
    changeset = Tick.changeset(%Tick{
      asset_id:  1,
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    })
    result = Trader.trade(changeset, Broker, Repo)

    assert [] == result
  end
end
