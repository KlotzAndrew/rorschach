defmodule WebServer.MarketConsumer do
  use GenServer

  alias WebServer.{TickHandler}

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    IO.puts "Starting stream..."
    {:ok, HTTPoison.get(url(), %{}, [timeout: :infinity, stream_to: self()])}
    IO.puts "TODO: handle steam failure"
    :timer.send_after(2_000, :consumer_failed)
    {:ok, []}
  end

  def listen do
    kafka_stream = KafkaEx.stream("test", 0, offset: 0, auto_commit: false)
    Enum.each(kafka_stream, fn(x) -> IO.inspect(x) end)
  end

  defp market_url, do: System.get_env("MARKET_URL") || "market_mock"

  defp url do
    "http://#{market_url()}:5020/quoteStream?symbol=NFLX+AMZN"
  end

  def handle_info(:consumer_failed, state) do
    {:stop, :timeout, state}
  end

  def handle_info(msg, state) do
    parse_message(msg)
    {:noreply, state}
  end

  defp parse_message(%HTTPoison.AsyncChunk{chunk: chunk}) do
    TickHandler.parse(chunk)
  end

  defp parse_message(%HTTPoison.AsyncStatus{code: code}) do
    IO.puts "AsyncStatus: "
    IO.inspect code
  end

  defp parse_message(%HTTPoison.AsyncHeaders{headers: headers}) do
    IO.puts "AsyncHeaders: "
    IO.inspect headers
  end

  defp parse_message(%HTTPoison.Error{reason: reason}) do
    IO.puts "HTTPoison.Error: "
    IO.inspect reason
  end

  defp parse_message(msg) do
    IO.puts "HTTPoison unhandeled message: "
    IO.inspect msg
  end
end
