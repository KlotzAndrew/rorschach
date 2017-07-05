defmodule WebServer.DayBar do
  use WebServer.Web, :model

  schema "day_bars" do
    field :asset_id, :integer
    field :at_timestamp, :integer
    field :open_price, :decimal
    field :high_price, :decimal
    field :low_price, :decimal
    field :close_price, :decimal
    field :volume, :decimal

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:asset_id, :at_timestamp, :open_price, :high_price,
      :low_price, :close_price, :volume])
    |> validate_required([:asset_id, :at_timestamp])
  end
end
