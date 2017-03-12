defmodule WebServer.Trader do
  alias WebServer.{Asset, Trade, Repo}

  def trade(changeset, repo \\ Repo, roll \\ :rand.uniform(4)) do
    case roll do
      1 -> buy_stock(changeset, repo)
      2 -> sell_stock(changeset, repo)
      _ -> []
    end
  end

  defp buy_stock(changeset, repo) do
    cash  = repo.get_by!(Asset, ticker: "CASH:USD")
    asset = repo.get_by(Asset, ticker: changeset.data.ticker)

    trade = execute_trade(repo, changeset, asset, cash, 1)
    [trade]
  end

  defp sell_stock(changeset, repo) do
    cash  = repo.get_by!(Asset, ticker: "CASH:USD")
    asset = repo.get_by(Asset, ticker: changeset.data.ticker)

    trade = execute_trade(repo, changeset, asset, cash,-1)
    [trade]
  end

  defp execute_trade(repo, changeset, asset, cash, quantity) do
    cash_offset = Decimal.new(-1)
    price = changeset.data.ask_price
    cash_total = Decimal.mult(price,  Decimal.new(quantity)) |> Decimal.mult(cash_offset)
    repo.insert! Trade.changeset(%Trade{
      portfolio_id: 1,
      asset_id:     asset.id,
      cash_id:      cash.id,
      quantity:     quantity,
      price:        price,
      cash_total:   cash_total,
      type:         "Buy"
    })
  end
end
