defmodule WebServer.TradeRepoTest do
  use WebServer.ModelCase

  alias WebServer.{TradeRepo, Repo, Trade}

  test "stocks" do
    Repo.insert! Trade.changeset(%Trade{portfolio_id: 1, asset_id: 1, quantity: 1, cash_total: 1, type: "Buy", cash_id: 1}, %{})
    Repo.insert! Trade.changeset(%Trade{portfolio_id: 1, asset_id: 1, quantity: 1, cash_total: 1, type: "Buy", cash_id: 1}, %{})
    Repo.insert! Trade.changeset(%Trade{portfolio_id: 2, asset_id: 1, quantity: 1, cash_total: 1, type: "Buy", cash_id: 1}, %{})
    Repo.insert! Trade.changeset(%Trade{portfolio_id: 2, asset_id: 2, quantity: 1, cash_total: 1, type: "Buy", cash_id: 1}, %{})
    Repo.insert! Trade.changeset(%Trade{portfolio_id: 2, asset_id: nil, quantity: 1, cash_total: 1, type: "Buy", cash_id: 1}, %{})

    assert TradeRepo.stocks(1) == [{1, 2}]
  end
end
