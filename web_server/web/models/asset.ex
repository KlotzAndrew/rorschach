defmodule WebServer.Asset do
  use WebServer.Web, :model

  schema "assets" do
    field :name, :string
    field :ticker, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :ticker])
    |> validate_required([:name, :ticker])
  end
end
