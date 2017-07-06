defmodule WebServer.DayBarTest do
  use WebServer.ModelCase

  alias WebServer.DayBar

  @valid_attrs %{asset_id: 1, at_timestamp: Ecto.DateTime.utc}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = DayBar.changeset(%DayBar{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = DayBar.changeset(%DayBar{}, @invalid_attrs)
    refute changeset.valid?
  end
end
