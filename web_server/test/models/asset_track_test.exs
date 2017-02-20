defmodule WebServer.AssetTrackTest do
  use WebServer.ModelCase

  alias WebServer.AssetTrack

  @valid_attrs %{asset_id: 42, portfolio_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AssetTrack.changeset(%AssetTrack{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AssetTrack.changeset(%AssetTrack{}, @invalid_attrs)
    refute changeset.valid?
  end
end
