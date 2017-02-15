defmodule WebServer.Asset do
  use WebServer.Web, :model

  schema "assets" do
    field :name, :string
    field :ticker, :string
    field :exchange, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :ticker, :exchange])
    |> validate_required([:name, :ticker, :exchange])
  end
end
