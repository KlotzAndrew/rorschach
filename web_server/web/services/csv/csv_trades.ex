defmodule WebServer.CSVBuilder do
  alias WebServer.{Repo, Asset, TradeRepo}
  alias Ecto.{DateTime}

  def dump_trades(portfolio_id, repo \\ Repo, trades_repo \\ TradeRepo) do
    assets_map = repo.all(Asset) |> normalize_objs
    trades = trades_repo.trades_for_portfolio(portfolio_id)
    headers = "asset,quantity,price,cash_total,type,inserted_at\n"

    Enum.reduce(trades, headers, fn(t, acc) ->
      string =
        to_s(asset_name(t.asset_id, assets_map)) <> "," <>
        to_s(t.quantity) <>  "," <>
        to_s(t.price) <>  "," <>
        to_s(t.cash_total) <>  "," <>
        to_s(t.type) <> "," <>
        to_s(t.inserted_at)

        acc <> string <> "\n"
    end)
  end

  defp to_s(v), do: Poison.encode!(v) |> String.replace("\"", "")

  defp normalize_objs(objects) do
    Enum.reduce(objects, %{}, fn(o, acc) -> Map.put(acc, o.id, o) end)
  end

  defp asset_name(nil, _map), do: nil
  defp asset_name(id, map) do
    map[id].name
  end
end
