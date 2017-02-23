defmodule WebServer.Trader do
  alias WebServer.Trade
  alias WebServer.Repo
  alias WebServer.Asset

  def trade(changeset, repo \\ Repo, roll \\ :rand.uniform(4)) do
    case roll do
      1 -> buy_stock(changeset, repo)
      2 -> sell_stock(changeset, repo)
    end
  end

  defp buy_stock(changeset, repo) do
    cash_asset = repo.get_by!(Asset, ticker: "CURRENCY:USD")
    asset      = repo.get_by(Asset, ticker: changeset.data.ticker)

    trade_for_asset(repo, changeset, asset, cash_asset, 1)
    trade_for_cash(repo, changeset, asset, cash_asset, -1)
  end

  defp sell_stock(changeset, repo) do
    cash_asset = repo.get_by!(Asset, ticker: "CURRENCY:USD")
    asset      = repo.get_by(Asset, ticker: changeset.data.ticker)

    trade_for_asset(repo, changeset, asset, cash_asset, -1)
    trade_for_cash(repo, changeset, asset, cash_asset, 1)
  end

  defp trade_for_asset(repo, changeset, asset, cash_asset, direction) do
    repo.insert! Trade.changeset(%Trade{
      portfolio_id:  1,
      from_asset_id: cash_asset.id,
      to_asset_id:   asset.id,
      quantity:      1 * direction,
      price:         changeset.data.ask_price
    })
  end

  defp trade_for_cash(repo, changeset, asset, cash_asset, direction) do
    repo.insert Trade.changeset(%Trade{
      portfolio_id:  1,
      from_asset_id: asset.id,
      to_asset_id:   cash_asset.id,
      quantity:      -1 * Decimal.to_integer(changeset.data.ask_price) * direction,
      price:         1
    })
  end
end
