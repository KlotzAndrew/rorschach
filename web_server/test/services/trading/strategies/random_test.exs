defmodule RandomTest do
  use ExUnit.Case, async: true

  alias WebServer.{Random}

  test "calculate_trade" do
    assert {:buy, 1} == Random.calculate_trade(1)
    assert {:sell, -1} == Random.calculate_trade(2)
    assert nil == Random.calculate_trade(4)
  end
end
