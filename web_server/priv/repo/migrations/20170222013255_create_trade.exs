defmodule WebServer.Repo.Migrations.CreateTrade do
  use Ecto.Migration

  def change do
    create table(:trades) do
      add :portfolio_id, :integer
      add :from_asset_id, :integer
      add :to_asset_id, :integer
      add :quantity, :integer
      add :price, :decimal

      timestamps()
    end

  end
end
