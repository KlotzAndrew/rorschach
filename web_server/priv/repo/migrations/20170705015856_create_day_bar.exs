defmodule WebServer.Repo.Migrations.CreateDayBar do
  use Ecto.Migration

  def change do
    create table(:day_bars) do
      add :asset_id, :integer, null: false
      add :at_timestamp, :integer, null: false, unique: true
      add :open_price, :decimal, precision: 15, scale: 2
      add :high_price, :decimal, precision: 15, scale: 2
      add :low_price, :decimal, precision: 15, scale: 2
      add :close_price, :decimal, precision: 15, scale: 2
      add :volume, :decimal, precision: 15, scale: 2

      timestamps()
    end
    
    create index(:day_bars, [:asset_id])
  end
end
