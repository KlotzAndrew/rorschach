defmodule Court.ArbiterTest do
  use ExUnit.Case, async: true

  alias WebServer.{Tick}
  alias Court.{Arbiter}

  test "decides bases on signals" do
    tick_cs = Tick.changeset(%Tick{}, %{
      ticker:    "NTFX",
      ask_price: Decimal.new(50)
    })
    signals = %{
      "NTFX" => %{
        "enter"  => Decimal.new(90),
        "exit"   => Decimal.new(100),
        "traded" => false
      }
    }
    decision = Arbiter.decide(signals, tick_cs)

    assert decision == {:buy, 1}
  end

  test "does nothing when no signals" do
    tick_cs = Tick.changeset(%Tick{}, %{
      ticker:    "NTFX",
      ask_price: Decimal.new(50)
    })
    signals = %{
      "NTFX" => %{
        "enter"  => nil,
        "exit"   => nil,
        "traded" => false
      }
    }
    decision = Arbiter.decide(signals, tick_cs)

    assert decision == nil
  end

  test "only trade once per cycle" do
    tick_cs = Tick.changeset(%Tick{}, %{
      ticker:    "NTFX",
      ask_price: Decimal.new(50)
    })
    signals = %{
      "NTFX" => %{
        "enter"  => Decimal.new(90),
        "exit"   => Decimal.new(100),
        "traded" => true
      }
    }
    decision = Arbiter.decide(signals, tick_cs)

    assert decision == nil
  end
end
