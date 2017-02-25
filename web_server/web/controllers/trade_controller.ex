defmodule WebServer.TradeController do
  use WebServer.Web, :controller

  alias WebServer.{Trade, AssetSums}

  def index(conn, _params) do
    trades = Repo.all(Trade)
    render(conn, "index.json", trades: trades)
  end

  def asset_sums(conn, %{"portfolio_id" => portfolio_id}) do
    sums = AssetSums.totals(portfolio_id)
    render(conn, "asset_sums.json", sums: sums)
  end

  def create(conn, %{"trade" => trade_params}) do
    changeset = Trade.changeset(%Trade{}, trade_params)

    case Repo.insert(changeset) do
      {:ok, trade} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", trade_path(conn, :show, trade))
        |> render("show.json", trade: trade)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(WebServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    trade = Repo.get!(Trade, id)
    render(conn, "show.json", trade: trade)
  end

  def update(conn, %{"id" => id, "trade" => trade_params}) do
    trade = Repo.get!(Trade, id)
    changeset = Trade.changeset(trade, trade_params)

    case Repo.update(changeset) do
      {:ok, trade} ->
        render(conn, "show.json", trade: trade)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(WebServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    trade = Repo.get!(Trade, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(trade)

    send_resp(conn, :no_content, "")
  end
end
