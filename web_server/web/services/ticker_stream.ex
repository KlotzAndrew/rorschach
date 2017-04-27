defmodule WebServer.TickerStream do
  require Logger
  use GenServer

  alias WebServer.{TickHandler}

  # @market_client "http://market_client:5000"
  # @demo_fields "&field=4+10+11"

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, listen()}
  end

  def listen do
    kafka_stream = KafkaEx.stream("test", 0, offset: 0, auto_commit: false)
    Enum.each(kafka_stream, fn(message) -> TickHandler.parse(message.value) end)
  end

  def parse_tick(tick) do
    TickHandler.parse(tick)
  end
end
