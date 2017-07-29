defmodule Court.SignalsTest do
  use ExUnit.Case, async: true

  alias WebServer.{Asset, DayBar}

  defmodule MockAssetRepo do
    def all_active_assets(_portfolio_id) do
      [
        %Asset{name: "asset_1", ticker: "A1", id: 1},
        %Asset{name: "asset_2", ticker: "A2", id: 2},
      ]
    end
  end

  defmodule MockDayBars do
    def fetch(_, _) do
      [
        DayBar.changeset(%DayBar{}, %{high_price: Decimal.new(30)}),
        DayBar.changeset(%DayBar{}, %{high_price: Decimal.new(110)}),
        DayBar.changeset(%DayBar{}, %{high_price: Decimal.new(130)}),
        DayBar.changeset(%DayBar{}, %{high_price: Decimal.new(130)})
      ]
    end
  end

  defmodule MockTradeRepo do
    def stocks(_) do
      [{1, 10}]
    end
  end

  test "calculate includes created_at time" do
    deps = %{
      asset_repo: MockAssetRepo,
      portfolio:  Portfolio,
      day_bars:   MockDayBars,
      asset_sums: MockTradeRepo,
    }
    signals = Court.Signals.calculate(1, deps)

    assert signals["created_at"] == "888"
  end

  test "calculate adds signals for each assets" do
    deps = %{
      asset_repo: MockAssetRepo,
      portfolio:  Portfolio,
      day_bars:   MockDayBars,
      asset_sums: MockTradeRepo,
    }
    signals = Court.Signals.calculate(1, deps)

    assert Map.keys(signals["signals"]) == ["A1", "A2"]
  end

  test "calculate adds values to asset" do
    deps = %{
      asset_repo: MockAssetRepo,
      portfolio:  Portfolio,
      day_bars:   MockDayBars,
      asset_sums: MockTradeRepo,
    }
    signals = Court.Signals.calculate(1, deps)
    expected_1 = %{
      "enter"    => Decimal.new(90.0),
      "exit"     => Decimal.new(110.0),
      "quantity" => 10,
      "traded"   => false
    }

    expected_2 = %{
      "enter"    => Decimal.new(90.0),
      "exit"     => Decimal.new(110.0),
      "quantity" => 0,
      "traded"   => false
    }

    assert signals["signals"]["A1"] == expected_1
    assert signals["signals"]["A2"] == expected_2
  end
end
