# mix run priv/repo/seeds.exs

alias WebServer.{Asset, Trade, Portfolio, Repo}

IO.puts "Seeding database..."

if Repo.aggregate(Portfolio, :count, :id) == 0 do
  Repo.transaction fn ->
    cash = Repo.insert! %Asset{name: "USD", ticker: "CASH:USD"}

    portfolio_1 = Repo.insert! %Portfolio{
      name:           "Rorschach portfolio",
      trade_strategy: "random"
    }
    Repo.insert! %Trade{
      portfolio_id: portfolio_1.id,
      cash_id:      cash.id,
      cash_total:   1_000_000,
      type:         "Deposit"
    }

    portfolio_2 = Repo.insert! %Portfolio{
      name:           "Yung portfolio",
      trade_strategy: "last_tick"
    }
    Repo.insert! %Trade{
      portfolio_id: portfolio_2.id,
      cash_id:      cash.id,
      cash_total:   1_000_000,
      type:         "Deposit"
    }
  end
end
