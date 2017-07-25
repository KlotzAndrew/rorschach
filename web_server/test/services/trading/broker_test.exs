defmodule BrokerTest do
  use ExUnit.Case, async: true

  alias WebServer.{Asset, Broker, Tick}

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
        changeset.data
      end
    end
  end

  test "buys stock" do
    portfolio_id = 1
    tick = %Tick{
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    }

    result = Broker.buy_stock(tick, portfolio_id, Repo)

    assert portfolio_id == result.portfolio_id
  end

  test "sells stock" do
    portfolio_id = 1
    tick = %Tick{
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    }

    result = Broker.sell_stock(tick, portfolio_id, Repo)

    assert portfolio_id == result.portfolio_id
  end
end
