defmodule WebServer.Repo.Migrations.CreateTrade do
  use Ecto.Migration

  def change do
    create table(:trades) do
      add :portfolio_id, :integer
      add :asset_id, :integer
      add :cash_id, :integer
      add :quantity, :integer
      add :price, :decimal
      add :cash_total, :decimal
      add :type, :string

      timestamps()
    end

  end
end
