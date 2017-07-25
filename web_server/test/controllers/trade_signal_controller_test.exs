defmodule WebServer.TradeSignalControllerTest do
  use WebServer.ConnCase

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  test "index returns signals for portfolio", %{conn: conn} do
    conn = get conn, "/api/v1/trade_signals/1"

    assert json_response(conn, 200)["data"]["attributes"]["signals"] == %{}
  end
end
