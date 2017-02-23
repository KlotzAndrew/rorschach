# mix run priv/repo/seeds.exs

alias WebServer.Repo
alias WebServer.Portfolio
alias WebServer.Asset
alias WebServer.Trade

if Repo.aggregate(Portfolio, :count, :id) == 0 do
  portfolio = Repo.insert! %Portfolio{
    name: "Rorschach portfolio"
  }
  asset = Repo.insert! %Asset{
    name:   "USD",
    ticker: "CURRENCY:USD"
  }
  Repo.insert! %Trade{
    portfolio_id: portfolio.id,
    to_asset_id:  asset.id,
    quantity:     1_000_000,
    price:        1,
  }
end
