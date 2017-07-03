defmodule WebServer.TickerStream do
  require Logger
  use GenServer

  alias WebServer.{TickHandler}

  # @market "http://market:5000"
  # @demo_fields "&field=4+10+11"

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def listen do
    kafka_stream = KafkaEx.stream("test", 0, offset: 0, auto_commit: false)
    Enum.each(kafka_stream, fn(message) -> TickHandler.parse(message.value) end)
  end

  def parse_tick(tick) do
    TickHandler.parse(tick)
  end

  # Callbacks

  def init(:ok) do
    GenServer.cast(self(), :listen)
    {:ok, []}
  end

  def handle_cast(:listen, state) do
    kafka_stream = KafkaEx.stream("test", 0, offset: 0, auto_commit: false)
    Enum.each(kafka_stream, fn(message) -> TickHandler.parse(message.value) end)

    IO.puts "Listen block failed!"
    :timer.sleep(5_000)
    GenServer.cast(self(), :listen)

    {:noreply, state}
  end
end
