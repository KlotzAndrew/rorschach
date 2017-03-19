defmodule WebServer.TickControllerTest do
  use WebServer.ConnCase

  alias WebServer.Tick
  @valid_attrs %{asset_id: 42, name: "some content", price: "120.5"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/vnd.api+json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, tick_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  @tag :skip
  test "shows chosen resource", %{conn: conn} do
    tick = Repo.insert! %Tick{}
    conn = get conn, tick_path(conn, :show, tick)
    assert json_response(conn, 200)["data"] == %{"id" => tick.id,
      "name" => tick.name,
      "asset_id" => tick.asset_id,
      "price" => tick.price}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, tick_path(conn, :show, -1)
    end
  end

  @tag :skip
  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, tick_path(conn, :create), tick: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Tick, @valid_attrs)
  end

  @tag :skip
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, tick_path(conn, :create), tick: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag :skip
  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    tick = Repo.insert! %Tick{}
    conn = put conn, tick_path(conn, :update, tick), tick: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Tick, @valid_attrs)
  end

  @tag :skip
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    tick = Repo.insert! %Tick{}
    conn = put conn, tick_path(conn, :update, tick), tick: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag :skip
  test "deletes chosen resource", %{conn: conn} do
    tick = Repo.insert! %Tick{}
    conn = delete conn, tick_path(conn, :delete, tick)
    assert response(conn, 204)
    refute Repo.get(Tick, tick.id)
  end
end
