defmodule LastTickTest do
  use ExUnit.Case, async: true

  alias WebServer.{Tick, LastTick}

  defmodule TickStore do
    def get(_changeset) do
      [
        Tick.changeset(%Tick{
          asset_id:  1,
          ticker:    "GOOG",
          ask_price: Decimal.new(100),
        })
      ]
    end
  end

  defmodule EmptyStore do
    def get(_changeset), do: []
  end

  test "calculate_trade for buy" do
    changeset = Tick.changeset(%Tick{
      asset_id:  1,
      ticker:    "GOOG",
      ask_price: Decimal.new(10),
    })

    result = LastTick.calculate_trade(nil, changeset, TickStore)

    assert result == {:buy, 1}
  end

  test "calculate_trade for sell" do
    changeset = Tick.changeset(%Tick{
      asset_id:  1,
      ticker:    "GOOG",
      ask_price: Decimal.new(200),
    })

    result = LastTick.calculate_trade(nil, changeset, TickStore)

    assert result == {:sell, -1}
  end


  test "calculate_trade for nil" do
    changeset = Tick.changeset(%Tick{
      asset_id:  1,
      ticker:    "GOOG",
      ask_price: Decimal.new(200),
    })

    result = LastTick.calculate_trade(nil, changeset, EmptyStore)

    assert result == nil
  end
end
