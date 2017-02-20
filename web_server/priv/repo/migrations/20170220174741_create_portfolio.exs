defmodule WebServer.Repo.Migrations.CreatePortfolio do
  use Ecto.Migration

  def change do
    create table(:portfolios) do
      add :name, :string, null: false

      timestamps()
    end

  end
end
