defmodule Court.JudgeTest do
  use ExUnit.Case, async: true

  defmodule MockSignals do
    def calculate(id) do
      %{"GOOG": %{"entry": 100, "exit": 200, "id": id}}
    end
  end

  defmodule MockRegistry do
    def add(_id, _pid) do
      send :judge_test_setup, :added_register
    end
  end

  defmodule MockArbiter do
    def decide(_signals, _tick_cs) do
      "decision_123"
    end
  end

  test "setup returns signals" do
    Process.register self(), :judge_test_setup

    {:ok, judge} = Court.Judge.start_link(4, MockSignals, MockRegistry)
    expected_signals = %{"GOOG": %{"entry": 100, "exit": 200, "id": 4}}

    assert Court.Judge.signals(judge) == expected_signals
    assert_receive :added_register
  end

  test "recommend returns recomendation" do
    Process.register self(), :judge_test_setup

    {:ok, judge} = Court.Judge.start_link(5, MockSignals, MockRegistry)

    recomendation = Court.Judge.recommend_by_pid(judge, "tick_cs", MockArbiter)
    assert recomendation == "decision_123"

    assert_receive :added_register
  end
end
