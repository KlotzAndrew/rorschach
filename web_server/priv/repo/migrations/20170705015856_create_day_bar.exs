defmodule WebServer.Repo.Migrations.CreateDayBar do
  use Ecto.Migration

  def change do
    create table(:day_bars) do
      add :asset_id, :integer, null: false
      add :at_timestamp, :utc_datetime, null: false
      add :open_price, :decimal, precision: 15, scale: 2
      add :high_price, :decimal, precision: 15, scale: 2
      add :low_price, :decimal, precision: 15, scale: 2
      add :close_price, :decimal, precision: 15, scale: 2
      add :volume, :integer

      timestamps()
    end

    create unique_index(:day_bars, [:asset_id, :at_timestamp], name: :unique_timestamp)
  end
end
