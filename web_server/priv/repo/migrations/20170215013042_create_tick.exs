defmodule WebServer.Repo.Migrations.CreateTick do
  use Ecto.Migration

  def change do
    create table(:ticks) do
      add :name, :string, null: false
      add :asset_id, :integer, null: false
      add :price, :decimal, precision: 15, scale: 2
      add :time, :utc_datetime

      timestamps()
    end

  end
end
