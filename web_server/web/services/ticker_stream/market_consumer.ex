defmodule WebServer.MarketConsumer do
  use GenServer

  alias WebServer.{AssetRepository, AtClient, TickHandler}

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    IO.puts "Starting stream..."
    :timer.send_after(2_000, :start_consume)
    {:ok, nil}
  end

  def update_stream do
    GenServer.call(__MODULE__, {:update_consume})
  end

  defp url do
    tickers = AssetRepository.all_stock_tickers
    AtClient.streaming_url(tickers)
  end

  defp rollover_stream(old_id) do
    {:ok, %HTTPoison.AsyncResponse{id: id}} =
      HTTPoison.get(url(), %{}, [recv_timeout: :infinity, stream_to: self()])

    if old_id, do: :hackney.stop_async(old_id)

    id
  end

  # Callbacks

  def handle_call({:update_consume}, _from, state) do
    id = rollover_stream(state)
    {:reply, :ok, id}
  end

  def handle_info(:start_consume, state) do
      id = rollover_stream(state)
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
