defmodule WebServer.AssetTrackControllerTest do
  use WebServer.ConnCase

  alias WebServer.AssetTrack
  @valid_attrs %{asset_id: 42, portfolio_id: 42}
  @invalid_attrs %{asset_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, asset_track_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    asset_track = Repo.insert! AssetTrack.changeset(%AssetTrack{}, @valid_attrs)
    conn = get conn, asset_track_path(conn, :show, asset_track)
    assert json_response(conn, 200)["data"] == %{"id" => asset_track.id,
      "portfolio_id" => asset_track.portfolio_id,
      "asset_id" => asset_track.asset_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, asset_track_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, asset_track_path(conn, :create), asset_track: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(AssetTrack, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, asset_track_path(conn, :create), asset_track: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    asset_track = Repo.insert! AssetTrack.changeset(%AssetTrack{}, @valid_attrs)
    conn = put conn, asset_track_path(conn, :update, asset_track), asset_track: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(AssetTrack, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    asset_track = Repo.insert! AssetTrack.changeset(%AssetTrack{}, @valid_attrs)
    conn = put conn, asset_track_path(conn, :update, asset_track), asset_track: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    asset_track = Repo.insert! AssetTrack.changeset(%AssetTrack{}, @valid_attrs)
    conn = delete conn, asset_track_path(conn, :delete, asset_track)
    assert response(conn, 204)
    refute Repo.get(AssetTrack, asset_track.id)
  end
end
