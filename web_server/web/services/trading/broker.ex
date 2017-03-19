defmodule WebServer.Broker do
  alias WebServer.{Asset, Trade, Repo}

  def buy_stock(changeset, portfolio_id, repo \\ Repo) do
    cash  = repo.get_by!(Asset, ticker: "CASH:USD")
    asset = repo.get_by!(Asset, ticker: changeset.data.ticker)

    execute_trade(repo, changeset, portfolio_id, asset, cash, 1)
  end

  def sell_stock(changeset, portfolio_id, repo \\ Repo) do
    cash  = repo.get_by!(Asset, ticker: "CASH:USD")
    asset = repo.get_by!(Asset, ticker: changeset.data.ticker)

    execute_trade(repo, changeset, portfolio_id, asset, cash, -1)
  end

  defp build_trade(changeset, portfolio_id, asset, cash, quantity) do
    cash_offset = Decimal.new(-1)
    price       = changeset.data.ask_price
    cash_total  = Decimal.mult(price,  Decimal.new(quantity)) |> Decimal.mult(cash_offset)

    Trade.changeset(%Trade{
      portfolio_id: portfolio_id,
      asset_id:     asset.id,
      cash_id:      cash.id,
      quantity:     quantity,
      price:        price,
      cash_total:   cash_total,
      type:         "Buy"
    })
  end

  defp execute_trade(repo, changeset, portfolio_id, asset, cash, quantity) do
    changeset = build_trade(changeset, portfolio_id, asset, cash, quantity)
    repo.insert! changeset
  end
end
