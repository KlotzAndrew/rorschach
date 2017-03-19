defmodule WebServer.Portfolio do
  use WebServer.Web, :model

  schema "portfolios" do
    field :name, :string
    field :trade_strategy, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :trade_strategy])
    |> validate_required([:name])
  end
end
