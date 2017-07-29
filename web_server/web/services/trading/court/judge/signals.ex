defmodule Court.Signals do
  alias WebServer.{AssetRepo, Portfolio, TradeRepo}
  alias AtClient.{DayBars}

  def calculate(porfolio_id, deps \\ calculate_deps()) do
    assets = deps[:asset_repo].all_active_assets(porfolio_id)
    asset_totals = deps[:asset_sums].stocks(porfolio_id)

    details = %{}
    details = Map.put(details, "signals", signals(assets, asset_totals, deps[:day_bars]))

    Map.put(details, "created_at", "888")
  end

  defp signals(assets, asset_totals, day_bars) do
    Enum.reduce(assets, %{}, fn(asset, acc) ->
      bars_results = day_bars.fetch(asset, 30)
      quantity = find_quantity(asset.id, asset_totals)
      Map.put(acc, asset.ticker, trade_signals(bars_results, quantity))
    end)
  end

  defp find_quantity(asset_id, totals) do
    case Enum.find(
    totals, fn({id, _q}) -> id == asset_id end) do
      {_id, q} -> q
      nil      -> 0
    end
  end

  defp trade_signals([], nil) do
    %{
      "enter"    => nil,
      "exit"     => nil,
      "traded"   => false,
      "quantity" => 0
    }
  end

  defp trade_signals(bars_results, quantity) do
    average = avg_from_bar_results(bars_results)
    enter_signal = Decimal.mult(average, Decimal.new(0.9))
    exit_signal = Decimal.mult(average, Decimal.new(1.1))

    %{
      "enter"    => enter_signal,
      "exit"     => exit_signal,
      "traded"   => false,
      "quantity" => quantity
    }
  end

  defp avg_from_bar_results(results) do
    sum = Enum.reduce(results, Decimal.new(0), fn(result, acc) ->
      Decimal.add(acc, result.params["high_price"])
    end)
    Decimal.div(sum, Decimal.new(Enum.count(results)))
  end

  defp calculate_deps do
    %{
      asset_repo: AssetRepo,
      portfolio:  Portfolio,
      day_bars:   DayBars,
      asset_sums: TradeRepo
    }
  end
end
