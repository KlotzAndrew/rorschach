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

  test "parses stream chunk" do
    TickHandler.parse("Q,TSLA,0,K,Q,280.650000,280.770000,1,5,20170215125426269\n", Repo)
    assert_receive :insert
  end
end
