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

  defmodule JudgeMock do
    def recommend(_portfolio, tick_cs) do
      cond do
        tick_cs.asset_id == 1 -> {:buy, 1}
        tick_cs.asset_id == 2 -> {:sell, -1}
        tick_cs.asset_id == 3 -> nil
      end
    end
  end

  test "buys or sells a single stock" do
    tick = %Tick{
      asset_id:  1,
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    }
    result = Trader.trade(tick, Broker, Repo, JudgeMock)
    buy_or_sell = Enum.at(result, 0)

    assert buy_or_sell in ["buy", "sell", nil] == true
  end

  test "no trade" do
    tick = %Tick{
      asset_id:  3,
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    }
    result = Trader.trade(tick, Broker, Repo, JudgeMock)

    assert [] == result
  end
end
