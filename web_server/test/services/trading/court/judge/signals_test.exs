defmodule Court.SignalsTest do
  use ExUnit.Case, async: true

  alias WebServer.{Asset}

  defmodule MockRepo do
    def all(Asset) do
      [
        %Asset{name: "asset_1", ticker: "A1", id: 1},
        %Asset{name: "asset_2", ticker: "A2", id: 2},
      ]
    end
  end

  test "calculate includes created_at time" do
    deps = %{
      repo: MockRepo,
      portfolio: Portfolio,
      asset: Asset
    }
    signals = Court.Signals.calculate(1, deps)

    assert signals["created_at"] == "888"
  end

  test "calculate adds signals for each assets" do
    deps = %{
      repo: MockRepo,
      portfolio: Portfolio,
      asset: Asset
    }
    signals = Court.Signals.calculate(1, deps)

    assert Map.keys(signals["signals"]) == ["A1", "A2"]
  end

  test "calculate adds enter and exit" do
    deps = %{
      repo: MockRepo,
      portfolio: Portfolio,
      asset: Asset
    }
    signals = Court.Signals.calculate(1, deps)
    expected = %{"enter" => 72.0, "exit" => 88.0, "traded" => false}

    assert signals["signals"]["A1"] == expected
  end
end
