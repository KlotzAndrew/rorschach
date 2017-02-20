defmodule WebServer.PortfolioController do
  use WebServer.Web, :controller

  alias WebServer.Portfolio

  def index(conn, _params) do
    portfolios = Repo.all(Portfolio)
    render(conn, "index.json", portfolios: portfolios)
  end

  def create(conn, %{"portfolio" => portfolio_params}) do
    changeset = Portfolio.changeset(%Portfolio{}, portfolio_params)

    case Repo.insert(changeset) do
      {:ok, portfolio} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", portfolio_path(conn, :show, portfolio))
        |> render("show.json", portfolio: portfolio)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(WebServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    portfolio = Repo.get!(Portfolio, id)
    render(conn, "show.json", portfolio: portfolio)
  end

  def update(conn, %{"id" => id, "portfolio" => portfolio_params}) do
    portfolio = Repo.get!(Portfolio, id)
    changeset = Portfolio.changeset(portfolio, portfolio_params)

    case Repo.update(changeset) do
      {:ok, portfolio} ->
        render(conn, "show.json", portfolio: portfolio)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(WebServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    portfolio = Repo.get!(Portfolio, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(portfolio)

    send_resp(conn, :no_content, "")
  end
end
