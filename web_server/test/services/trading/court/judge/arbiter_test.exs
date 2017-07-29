defmodule Court.ArbiterTest do
  use ExUnit.Case, async: true

  alias WebServer.{Tick, Trade}
  alias Court.{Arbiter}

  @tick %Tick{
    ticker:    "NFLX",
    ask_price: Decimal.new(50)
  }

  test "decides does nothing when no signals" do
    signals = %{
      "NFLX" => %{
        "enter"  => nil,
        "exit"   => nil,
        "traded" => false
      }
    }
    result = Arbiter.decide(signals, @tick)

    assert result[:decision] == nil
  end

  test "no trade for no signals" do
    signals = %{}
    result = Arbiter.decide(signals, @tick)

    assert result[:decision] == nil
  end

  test "decides no buy when traded" do
    signals = %{
      "NFLX" => %{
        "enter"    => Decimal.new(90),
        "exit"     => Decimal.new(100),
        "quantity" => 1,
        "traded"   => true
      }
    }
    result = Arbiter.decide(signals, @tick)

    assert result[:decision] == nil
  end

  test "decides does not sell for q=0" do
    signals = %{
      "NFLX" => %{
        "enter"    => Decimal.new(9),
        "exit"     => Decimal.new(10),
        "quantity" => 0,
        "traded"   => true
      }
    }
    result = Arbiter.decide(signals, @tick)

    assert result[:decision] == nil
  end

  test "decide for close decimal compares" do
    tick = %Tick{ticker: "NFLX", ask_price: Decimal.new(-1)}
    signals = %{
      "NFLX" => %{
        "enter"    => Decimal.new(0),
        "exit"     => Decimal.new(10),
        "quantity" => 0,
        "traded"   => false
      }
    }

    result = Arbiter.decide(signals, tick)

    assert result[:decision] == {:buy, 1}
  end

  test "decide updates signals" do
    signals = %{
      "NFLX" => %{
        "enter"    => Decimal.new(90),
        "exit"     => Decimal.new(100),
        "quantity" => 0,
        "traded"   => false
      }
    }
    after_buy = %{
      "NFLX" => %{
        "enter"    => Decimal.new(90),
        "exit"     => Decimal.new(100),
        "quantity" => 1,
        "traded"   => true
      }
    }
    result = Arbiter.decide(signals, @tick)

    assert result[:decision] == {:buy, 1}
    assert result[:signals] == after_buy

    sell_tick = %Tick{ticker: "NFLX", ask_price: Decimal.new(500) }

    result = Arbiter.decide(result[:signals], sell_tick)
    assert result[:decision] == {:sell, -1}
    assert result[:signals] == signals
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
