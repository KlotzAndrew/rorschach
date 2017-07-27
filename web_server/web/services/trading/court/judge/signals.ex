defmodule Court.Signals do
  alias WebServer.{AssetRepo, Portfolio}
  alias AtClient.{DayBars}

  def calculate(_porfolio_id, deps \\ calculate_deps()) do
    assets = deps[:asset_repo].all_non_cash

    details = %{}
    details = Map.put(details, "signals", signals(assets, deps[:day_bars]))

    Map.put(details, "created_at", "888")
  end

  defp signals(assets, day_bars) do
    Enum.reduce(assets, %{}, fn(asset, acc) ->
      bars_results = day_bars.fetch(asset, 30)
      Map.put(acc, asset.ticker, trade_signals(bars_results))
    end)
  end

  defp trade_signals([]) do
    %{
      "enter" => nil,
      "exit" => nil,
      "traded" => false
    }
  end

  defp trade_signals(bars_results) do
    average = avg_from_bar_results(bars_results)
    enter_signal = Decimal.mult(average, Decimal.new(0.9))
    exit_signal = Decimal.mult(average, Decimal.new(1.1))

    %{
      "enter" => enter_signal,
      "exit" => exit_signal,
      "traded" => false
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
      portfolio: Portfolio,
      day_bars: DayBars
    }
  end
end
