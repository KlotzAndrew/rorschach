defmodule BroadcasterTest do
  use ExUnit.Case, async: true

  alias WebServer.{Broadcaster, Trade}

  defmodule Endpoint do
    def broadcast!("room:lobby", "new:trade", _message) do
      send self(), :broadcasted
    end
  end

  test "broadcasts trade" do
    trade = %Trade{}
    Broadcaster.broadcast_trade(trade, Endpoint)

    assert_receive :broadcasted
  end

  test "broadcasts trades" do
    trade = %Trade{}
    Broadcaster.broadcast_trades([trade, trade], Endpoint)

    assert_receive :broadcasted
  end
end
