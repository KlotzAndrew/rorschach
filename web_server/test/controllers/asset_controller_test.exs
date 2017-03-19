defmodule WebServer.AssetControllerTest do
  use WebServer.ConnCase

  alias WebServer.Asset
  @valid_attrs %{name: "Google Inc.", ticker: "GOOG"}
  @invalid_attrs %{ticker: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/vnd.api+json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, asset_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    asset = Repo.insert! Asset.changeset(%Asset{}, @valid_attrs)
    conn = get conn, asset_path(conn, :show, asset)
    assert json_response(conn, 200)["data"] == %{"id" => asset.id,
      "name" => asset.name,
      "ticker" => asset.ticker}
  end

  test "searches chosen resource when present", %{conn: conn} do
    asset = Repo.insert! Asset.changeset(%Asset{}, @valid_attrs)
    conn = post conn, asset_path(conn, :search), ticker: asset.ticker
    assert json_response(conn, 200)["data"] == %{"id" => asset.id,
      "name" => asset.name,
      "ticker" => asset.ticker}
  end

  @tag :skip
  test "searches chosen resource when not present", %{conn: conn} do
    conn = post conn, asset_path(conn, :search), ticker: @valid_attrs.ticker
    data = json_response(conn, 200)["data"]
    assert data["name"] == @valid_attrs.name
    assert data["ticker"] == @valid_attrs.ticker
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, asset_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, asset_path(conn, :create), asset: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Asset, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, asset_path(conn, :create), asset: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    asset = Repo.insert! Asset.changeset(%Asset{}, @valid_attrs)
    conn = put conn, asset_path(conn, :update, asset), asset: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Asset, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    asset = Repo.insert! Asset.changeset(%Asset{}, @valid_attrs)
    conn = put conn, asset_path(conn, :update, asset), asset: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    asset = Repo.insert! Asset.changeset(%Asset{}, @valid_attrs)
    conn = delete conn, asset_path(conn, :delete, asset)
    assert response(conn, 204)
    refute Repo.get(Asset, asset.id)
  end
end
