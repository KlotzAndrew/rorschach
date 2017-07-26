defmodule Court.JudgeTest do
  use ExUnit.Case, async: true

  alias WebServer.{Tick, Trade}

  defmodule MockSignals do
    def calculate(id) do
      %{
        "created_at" => "888",
        "signals" => %{"GOOG" => %{"entry" => 100, "exit" => 200, "id" => id}}
      }
    end
  end

  defmodule MockRegistry do
    def add(_id, _pid) do
      send :judge_test_setup, :added_register
    end
  end

  defmodule MockArbiter do
    def decide(_signals, _tick_cs) do
      %{
        decision: "decision_123",
        signals: "new signals 888!"
      }
    end

    def new_trade_info(_state, _trade, _tick) do
      "new_signals"
    end
  end

  test "setup returns signals for string id" do
    Process.register self(), :judge_test_setup

    {:ok, judge} = Court.Judge.start_link("4", MockSignals, MockRegistry)
    expected_signals = %{
      "created_at" => "888",
      "signals" => %{"GOOG" => %{"entry" => 100, "exit" => 200, "id" => 4}}
    }

    assert Court.Judge.signals(judge) == expected_signals
    assert_receive :added_register
  end

  test "recommend returns recomendation" do
    Process.register self(), :judge_test_setup

    {:ok, judge} = Court.Judge.start_link(5, MockSignals, MockRegistry)

    recomendation = Court.Judge.recommend_by_pid(judge, "tick", MockArbiter)
    assert recomendation == "decision_123"

    assert Court.Judge.signals(judge) == %{"created_at" => "888", "signals" => "new signals 888!"}

    assert_receive :added_register
  end

  test "hear_trade_by_pid updates state on new trade" do
    Process.register self(), :judge_test_setup
    tick = %Tick{
      asset_id:  3,
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    }
    trade = %Trade{quantity: 1}

    {:ok, judge} = Court.Judge.start_link(5, MockSignals, MockRegistry)

    result = Court.Judge.hear_trade_by_pid(judge, trade, tick, MockArbiter)
    assert result == %{"created_at" => "888", "signals" => "new_signals" }
  end
end
