defmodule RandomTest do
  use ExUnit.Case, async: true

  alias WebServer.{Random}

  test "calculate_trade" do
    assert {:buy, 1} == Random.calculate_trade(nil, nil, nil, 1)
    assert {:sell, -1} == Random.calculate_trade(nil, nil, nil, 2)
    assert nil == Random.calculate_trade(nil, nil, nil, 4)
  end
end
