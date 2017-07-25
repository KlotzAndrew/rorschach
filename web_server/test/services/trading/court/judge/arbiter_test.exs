defmodule Court.ArbiterTest do
  use ExUnit.Case, async: true

  alias WebServer.{Tick, Trade}
  alias Court.{Arbiter}

  @tick %Tick{
    ticker:    "NFLX",
    ask_price: Decimal.new(50)
  }

  test "decides bases on signals" do
    signals = %{
      "NFLX" => %{
        "enter"  => Decimal.new(90),
        "exit"   => Decimal.new(100),
        "traded" => false
      }
    }
    decision = Arbiter.decide(signals, @tick)

    assert decision == {:buy, 1}
  end

  test "does nothing when no signals" do
    signals = %{
      "NFLX" => %{
        "enter"  => nil,
        "exit"   => nil,
        "traded" => false
      }
    }
    decision = Arbiter.decide(signals, @tick)

    assert decision == nil
  end

  test "only trade once per cycle" do
    signals = %{
      "NFLX" => %{
        "enter"  => Decimal.new(90),
        "exit"   => Decimal.new(100),
        "traded" => true
      }
    }
    decision = Arbiter.decide(signals, @tick)

    assert decision == nil
  end

  test "no trade for no signals" do
    signals = %{}
    decision = Arbiter.decide(signals, @tick)

    assert decision == nil
  end

  test "new_trade_info updates traded" do
    signals = %{
      "NFLX" => %{
        "enter"  => Decimal.new(90),
        "exit"   => Decimal.new(100),
        "traded" => false
      }
    }
    trade = %Trade{quantity: 1}
    traded_signals = Arbiter.new_trade_info(signals, trade, @tick)

    assert traded_signals == %{
      "NFLX" => %{
        "enter"  => Decimal.new(90),
        "exit"   => Decimal.new(100),
        "traded" => true
      }
    }

    trade_sell = %Trade{quantity: -1}
    no_traded_signals = Arbiter.new_trade_info(traded_signals, trade_sell, @tick)

    assert no_traded_signals === signals
  end
end
