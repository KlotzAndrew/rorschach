defmodule TickHandlerTest do
  use ExUnit.Case, async: true

  alias WebServer.TickHandler

  defmodule Trader do
    def trade(_changeset) do
      send self(), :traded
    end
  end

  defmodule Broadcaster do
    def broadcast_trades(_trades) do
      send self(), :broadcasted
    end

    def broadcast_tick(_trades) do
      send self(), :broadcasted_tick
    end
  end

  test "parses stream chunk" do
    TickHandler.parse(
      "Q,TSLA,0,K,Q,280.650000,280.770000,1,5,20170215125426269\n",
      Trader,
      Broadcaster
    )
    assert_receive :traded
    assert_receive :broadcasted
    assert_receive :broadcasted_tick
  end
end
