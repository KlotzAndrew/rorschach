defmodule WebServer.TradeTest do
  use WebServer.ModelCase

  alias WebServer.Trade

  @valid_attrs %{cash_id: 42, price: "120.5", quantity: 42,
                 asset_id: 42, portfolio_id: 42, cash_total: "1.20", type: "Buy"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Trade.changeset(%Trade{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Trade.changeset(%Trade{}, @invalid_attrs)
    refute changeset.valid?
  end
end
