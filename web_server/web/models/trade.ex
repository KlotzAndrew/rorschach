defmodule WebServer.Trade do
  use WebServer.Web, :model

  schema "trades" do
    field :portfolio_id, :integer
    field :asset_id, :integer
    field :cash_id, :integer
    field :quantity, :integer
    field :price, :decimal
    field :cash_total, :decimal
    field :type, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params,
      [:asset_id, :cash_id, :quantity, :price, :portfolio_id, :cash_total,
       :type])
    |> validate_required(
      [:cash_id, :cash_total, :portfolio_id, :type])
  end
end
