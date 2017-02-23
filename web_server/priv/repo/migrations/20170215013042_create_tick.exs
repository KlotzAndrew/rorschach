defmodule WebServer.Repo.Migrations.CreateTick do
  use Ecto.Migration

  def change do
    create table(:ticks) do
      add :type, :string, null: false
      add :asset_id, :integer, null: false
      add :ticker, :string
      add :quote_condition, :integer, null: false
      add :bid_exchange, :string, null: false
      add :ask_exchange, :string, null: false
      add :bid_price, :decimal, precision: 15, scale: 2
      add :ask_price, :decimal, precision: 15, scale: 2
      add :bid_size, :decimal, precision: 15, scale: 2
      add :ask_size, :decimal, precision: 15, scale: 2
      add :time, :utc_datetime, null: false

      timestamps()
    end

  end
end
