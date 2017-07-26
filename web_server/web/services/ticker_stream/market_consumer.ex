defmodule WebServer.MarketConsumer do
  use GenServer

  alias WebServer.{TickHandler}

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    IO.puts "Starting stream..."
    :timer.send_after(2_000, :start_consume)
    {:ok, nil}
  end

  # defp market_url, do: System.get_env("MARKET_URL")

  defp url do
    # "#{market_url()}:5000/quoteStream?symbol=NFLX+AMZN"
    "http://market_mock:5020/quoteStream?symbol=NFLX+AMZN"
  end

  def handle_info(:start_consume, state) do
    if state do
      :hackney.stop_async state # TODO: can this error?
    end

    {:ok, %HTTPoison.AsyncResponse{id: id}} =
      HTTPoison.get(url(), %{}, [recv_timeout: :infinity, stream_to: self()])

    {:noreply, id}
  end

  def handle_info(%HTTPoison.AsyncResponse{id: id}, state) do
    IO.inspect id, label: "HTTPoison.AsyncResponse: "
    {:noreply, state}
  end

  def handle_info(%HTTPoison.AsyncStatus{code: code}, state) do
    IO.inspect code, label: "AsyncStatus: "
    {:noreply, state}
  end

  def handle_info(%HTTPoison.AsyncHeaders{headers: headers}, state) do
    IO.inspect headers, label: "AsyncHeaders: "
    {:noreply, state}
  end

  def handle_info(%HTTPoison.AsyncChunk{chunk: chunk}, state) do
    TickHandler.parse(chunk)
    {:noreply, state}
  end

  def handle_info(%HTTPoison.AsyncEnd{id: id}, _state) do
    IO.inspect id, label: "HTTPoison.AsyncEnd: "
    :timer.send_after(2_000, :start_consume)

    {:noreply, nil}
  end

  def handle_info(%HTTPoison.Error{reason: reason}, state) do
    IO.inspect reason, label: "HTTPoison.Error: "
    {:noreply, state}
  end

  def handle_info(msg, state) do
    IO.inspect msg, label: "MarketConsumer unknown message"
    {:noreply, state}
  end
end
