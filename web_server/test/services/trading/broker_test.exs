defmodule BrokerTest do
  use ExUnit.Case, async: true

  alias WebServer.{Asset, Broker, Tick, Trade}

  defmodule Repo do
    def get_by!(Asset, ticker: ticker) do
      case ticker do
        "CASH:USD" -> %Asset{id: 1}
        "GOOG" -> %Asset{id: 2}
        _ -> ""
      end
    end

    def insert!(changeset) do
      if changeset.valid? do
        changeset
      end
    end
  end

  test "buys stock" do
    portfolio_id = 1
    tick = %Tick{
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    }
    expected = %Trade{
      portfolio_id: 1,
      asset_id:     2,
      cash_id:      1,
      quantity:     1,
      price:        Decimal.new(100),
      cash_total:   Decimal.new(-100),
      type:         "Buy"
    }

    result = Broker.buy_stock(tick, portfolio_id, Repo)

    assert result.data == expected
  end

  test "sells stock" do
    portfolio_id = 1
    tick = %Tick{
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    }
    expected = %Trade{
      portfolio_id: 1,
      asset_id:     2,
      cash_id:      1,
      quantity:     -1,
      price:        Decimal.new(100),
      cash_total:   Decimal.new(100),
      type:         "Sell"
    }

    result = Broker.sell_stock(tick, portfolio_id, Repo)

    assert result.data == expected
  end
end
