defmodule WebServer.Tick do
  use WebServer.Web, :model

  schema "ticks" do
    field :type, :string
    field :asset_id, :integer
    field :quote_condition, :integer
    field :bid_exchange, :string
    field :ask_exchange, :string
    field :bid_price, :decimal
    field :ask_price, :decimal
    field :bid_size, :decimal
    field :ask_size, :decimal
    field :time, Ecto.DateTime

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type, :asset_id, :quote_condition, :bid_exchange,
      :ask_exchange, :bid_price, :ask_price, :bid_size, :ask_size, :time])
    |> validate_required([:asset_id])
  end
end
