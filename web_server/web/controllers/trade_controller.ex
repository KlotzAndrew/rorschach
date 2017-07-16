defmodule WebServer.TradeController do
  use WebServer.Web, :controller
  import Ecto.Query

  alias WebServer.{Trade, AssetSums}

  def index(conn, _params) do
    query = from t in Trade,
      order_by: [desc: t.inserted_at],
      limit: 10

    trades = Repo.all(query)
    render(conn, "index.json", trades: trades)
  end

  def cash_holdings(conn, %{"portfolio_id" => portfolio_id}) do
    holdings = AssetSums.cash(portfolio_id)
    render(conn, "asset_holdings.json", holdings: holdings)
  end

  def stock_holdings(conn, %{"portfolio_id" => portfolio_id}) do
    holdings = AssetSums.stocks(portfolio_id)
    render(conn, "asset_holdings.json", holdings: holdings)
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
end
