defmodule TickHandlerTest do
  use ExUnit.Case, async: true

  alias WebServer.TickHandler

  defmodule Repo do
    def insert!(changeset) do
      if changeset.valid? do
        send self(), :insert
      end
    end
  end

  defmodule Trader do
    def trade(changeset) do
      if changeset.valid? do
        send self(), :traded
      end
    end
  end

  defmodule Broadcaster do
    def broadcast_trades(_trades) do
      send self(), :broadcasted
    end
  end

  test "parses stream chunk" do
    TickHandler.parse(
      "Q,TSLA,0,K,Q,280.650000,280.770000,1,5,20170215125426269\n",
      Repo,
      Trader,
      Broadcaster
    )
    assert_receive :insert
    assert_receive :traded
    assert_receive :broadcasted
  end
end
