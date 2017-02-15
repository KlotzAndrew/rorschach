defmodule WebServer.AssetTest do
  use WebServer.ModelCase

  alias WebServer.Asset

  @valid_attrs %{exchange: "some content", name: "some content", ticker: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Asset.changeset(%Asset{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Asset.changeset(%Asset{}, @invalid_attrs)
    refute changeset.valid?
  end
end
