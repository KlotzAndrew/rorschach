defmodule TraderTest do
  use ExUnit.Case, async: true

  alias WebServer.Trader
  alias WebServer.Tick
  alias WebServer.Asset

  defmodule Repo do
    def get_by!(_asset, _ticker) do
      %Asset{id: 1}
    end

    def get_by(_asset, _ticker) do
      %Asset{id: 2}
    end

    def insert!(changeset) do
      if changeset.valid? do
        # changeset.data
        "trade_1"
      end
    end

    def insert(changeset) do
      if changeset.valid? do
        # changeset.data
        "trade_2"
      end
    end
  end

  test "buys stock" do
    changeset = Tick.changeset(%Tick{
      asset_id:  1,
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    })
    result = Trader.trade(changeset, Repo, 1)

    assert ["trade_1", "trade_2"] == result
  end

  test "sells stock" do
    changeset = Tick.changeset(%Tick{
      asset_id:  1,
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    })
    result = Trader.trade(changeset, Repo, 2)

    assert ["trade_1", "trade_2"] == result
  end
end
