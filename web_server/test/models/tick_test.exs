defmodule WebServer.TickTest do
  use WebServer.ModelCase

  alias WebServer.Tick

  @valid_attrs %{asset_id: 42, name: "some content", price: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tick.changeset(%Tick{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tick.changeset(%Tick{}, @invalid_attrs)
    refute changeset.valid?
  end
end
