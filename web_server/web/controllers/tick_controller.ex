defmodule WebServer.TickController do
  use WebServer.Web, :controller

  alias WebServer.Tick

  def index(conn, _params) do
    ticks = Repo.all(Tick)
    render(conn, "index.json", ticks: ticks)
  end

  def create(conn, %{"tick" => tick_params}) do
    changeset = Tick.changeset(%Tick{}, tick_params)

    case Repo.insert(changeset) do
      {:ok, tick} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", tick_path(conn, :show, tick))
        |> render("show.json", tick: tick)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(WebServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tick = Repo.get!(Tick, id)
    render(conn, "show.json", tick: tick)
  end

  def update(conn, %{"id" => id, "tick" => tick_params}) do
    tick = Repo.get!(Tick, id)
    changeset = Tick.changeset(tick, tick_params)

    case Repo.update(changeset) do
      {:ok, tick} ->
        render(conn, "show.json", tick: tick)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(WebServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tick = Repo.get!(Tick, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(tick)

    send_resp(conn, :no_content, "")
  end
end
