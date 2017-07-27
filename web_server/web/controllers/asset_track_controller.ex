defmodule WebServer.AssetTrackController do
  use WebServer.Web, :controller

  alias WebServer.{AssetTrack, AssetTrackRepo}

  def index(conn, _params) do
    asset_tracks = Repo.all(AssetTrack)
    render(conn, "index.json", asset_tracks: asset_tracks)
  end

  def create(conn, %{"asset_track" => asset_track_params}) do
    changeset = AssetTrack.changeset(%AssetTrack{}, asset_track_params)

    case Repo.insert(changeset) do
      {:ok, asset_track} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", asset_track_path(conn, :show, asset_track))
        |> render("show.json", asset_track: asset_track)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(WebServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    asset_track = Repo.get!(AssetTrack, id)
    render(conn, "show.json", asset_track: asset_track)
  end

  def toggle(conn, %{"active" => active, "portfolio_id" => portfolio_id, "asset_id" => asset_id}) do
    asset_track = AssetTrackRepo.toggle(active, portfolio_id, asset_id)
    render(conn, "show.json", asset_track: asset_track)
  end

  def update(conn, %{"id" => id, "asset_track" => asset_track_params}) do
    asset_track = Repo.get!(AssetTrack, id)
    changeset = AssetTrack.changeset(asset_track, asset_track_params)

    case Repo.update(changeset) do
      {:ok, asset_track} ->
        render(conn, "show.json", asset_track: asset_track)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(WebServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    asset_track = Repo.get!(AssetTrack, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(asset_track)

    send_resp(conn, :no_content, "")
  end
end
