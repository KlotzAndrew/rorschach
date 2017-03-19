defmodule WebServer.Repo.Migrations.CreatePortfolio do
  use Ecto.Migration

  def change do
    create table(:portfolios) do
      add :name, :string, null: false
      add :trade_strategy, :string

      timestamps()
    end

  end
end
