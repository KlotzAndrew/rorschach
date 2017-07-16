defmodule WebServer.TradeControllerTest do
  use WebServer.ConnCase

  alias WebServer.Trade
  @valid_attrs %{asset_id: 42, price: "120.5", quantity: 42, cash_id: 42,
                 portfolio_id: 42, cash_total: "88.88", type: "Buy"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/vnd.api+json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, trade_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    trade = Repo.insert! Trade.changeset(%Trade{}, @valid_attrs)
    conn = get conn, trade_path(conn, :show, trade)
    assert json_response(conn, 200)["data"] == %{"id" => trade.id,
      "quantity" => trade.quantity,
      "price" => Decimal.to_string(trade.price),
      "cash_id" => trade.cash_id,
      "asset_id" => trade.asset_id,
      "portfolio_id" => trade.portfolio_id,
      "type" => trade.type,
      "inserted_at" => NaiveDateTime.to_iso8601(trade.inserted_at)
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, trade_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, trade_path(conn, :create), trade: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Trade, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, trade_path(conn, :create), trade: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    trade = Repo.insert! Trade.changeset(%Trade{}, @valid_attrs)
    conn = put conn, trade_path(conn, :update, trade), trade: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Trade, @valid_attrs)
  end

  @tag :skip
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    trade = Repo.insert! Trade.changeset(%Trade{}, @valid_attrs)
    conn = put conn, trade_path(conn, :update, trade), trade: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end
