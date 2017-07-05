defmodule Court.Signals do
  alias WebServer.{Asset, Portfolio, Repo}

  def calculate(_porfolio_id, deps \\ calculate_deps()) do
    asset = deps[:asset]
    repo = deps[:repo]
    assets = repo.all(asset)

    details = %{}
    details = Map.put(details, "signals", signals(assets))

    Map.put(details, "created_at", "888")
  end

  defp signals(assets) do
    Enum.reduce(assets, %{}, fn(asset, acc) ->
      Map.put(acc, asset.ticker, trade_signals(asset))
    end)
  end

  defp trade_signals(_asset) do
    enter_signal = 80 * 0.9
    exit_signal = 80 * 1.1

    %{
      "enter" => enter_signal,
      "exit" => exit_signal,
      "traded" => false
    }
  end

  defp calculate_deps do
    %{
      repo: Repo,
      asset: Asset,
      portfolio: Portfolio
    }
  end
end
