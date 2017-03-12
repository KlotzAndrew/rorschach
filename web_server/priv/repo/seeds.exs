# mix run priv/repo/seeds.exs

alias WebServer.{Asset, Trade, Portfolio, Repo}

IO.puts "Seeding database..."

if Repo.aggregate(Portfolio, :count, :id) == 0 do
  Repo.transaction fn ->
    portfolio = Repo.insert! %Portfolio{
      name: "Rorschach portfolio"
    }
    cash = Repo.insert! %Asset{
      name:   "USD",
      ticker: "CASH:USD"
    }
    Repo.insert! %Trade{
      portfolio_id: portfolio.id,
      cash_id:      cash.id,
      cash_total:   1_000_000,
      type:         "Deposit"
    }
  end
end
