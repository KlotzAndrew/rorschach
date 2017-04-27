defmodule AtClientTest do
  use ExUnit.Case, async: true

  alias WebServer.{AtClient}

  test "steaming_url returns url" do
    tickers = ["A", "Z"]
    expected_url = "http://market_mock:5020/quoteStream?symbol=A+Z"

    url = AtClient.streaming_url(tickers)

    assert url == expected_url
  end

  @tag :skip
  test "builds tick from tick_values" do
    # TODO
  end
end
