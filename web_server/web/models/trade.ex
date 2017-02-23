defmodule WebServer.Trade do
  use WebServer.Web, :model

  schema "trades" do
    field :portfolio_id, :integer
    field :from_asset_id, :integer
    field :to_asset_id, :integer
    field :quantity, :integer
    field :price, :decimal

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:from_asset_id, :to_asset_id, :quantity, :price, :portfolio_id])
    |> validate_required([:from_asset_id, :to_asset_id, :quantity, :price, :portfolio_id])
  end
end
