defmodule WebServer.Repo.Migrations.CreateAssetTrack do
  use Ecto.Migration

  def change do
    create table(:asset_tracks) do
      add :portfolio_id, :integer, null: false
      add :asset_id, :integer, null: false
      add :active, :boolean, default: false, null: false

      timestamps()
    end

  end
end
