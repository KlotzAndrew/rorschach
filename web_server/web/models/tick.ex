defmodule WebServer.Tick do
  use WebServer.Web, :model

  schema "ticks" do
    field :name, :string
    field :asset_id, :integer
    field :price, :decimal

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :asset_id, :price])
    |> validate_required([:name, :asset_id, :price])
  end
end
