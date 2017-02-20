defmodule WebServer.AssetTrack do
  use WebServer.Web, :model

  schema "asset_tracks" do
    field :portfolio_id, :integer
    field :asset_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:portfolio_id, :asset_id])
    |> validate_required([:portfolio_id, :asset_id])
  end
end
