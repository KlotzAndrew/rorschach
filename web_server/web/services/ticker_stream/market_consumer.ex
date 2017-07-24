defmodule WebServer.MarketConsumer do
  use GenServer

  alias WebServer.{MarketReceiver}

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    IO.puts "Starting stream..."
    :timer.send_after(2_000, :start_consume)
    {:ok, []}
  end

  def listen do
    kafka_stream = KafkaEx.stream("test", 0, offset: 0, auto_commit: false)
    Enum.each(kafka_stream, fn(x) -> IO.inspect(x) end)
  end

  # defp market_url, do: System.get_env("MARKET_URL")

  defp url do
    # "#{market_url()}:5000/quoteStream?symbol=NFLX+AMZN"
    "http://market_mock:5020/quoteStream?symbol=NFLX+AMZN"
  end

  def handle_info(:start_consume, state) do
    {:ok, HTTPoison.get(url(), %{}, [timeout: :infinity, stream_to: MarketReceiver])}
    IO.inspect "TODO: MarketConsumer crash handler"
    {:stop, :timeout, state}
  end

  def handle_info(msg, state) do
    IO.inspect msg, "MarketConsumer unknown message"
    {:noreply, state}
  end
end
