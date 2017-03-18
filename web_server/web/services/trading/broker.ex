defmodule WebServer.Broker do
  alias WebServer.{Asset, Trade, Repo}

  def buy_stock(changeset, repo \\ Repo) do
    cash  = repo.get_by!(Asset, ticker: "CASH:USD")
    asset = repo.get_by!(Asset, ticker: changeset.data.ticker)

    trade = execute_trade(repo, changeset, asset, cash, 1)
    [trade]
  end

  def sell_stock(changeset, repo \\ Repo) do
    cash  = repo.get_by!(Asset, ticker: "CASH:USD")
    asset = repo.get_by!(Asset, ticker: changeset.data.ticker)

    trade = execute_trade(repo, changeset, asset, cash, -1)
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
