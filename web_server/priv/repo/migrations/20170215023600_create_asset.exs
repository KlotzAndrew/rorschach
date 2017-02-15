defmodule WebServer.Repo.Migrations.CreateAsset do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :name, :string, null: false
      add :ticker, :string, null: false
      add :exchange, :string

      timestamps()
    end

  end
end
