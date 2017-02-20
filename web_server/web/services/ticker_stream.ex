defmodule WebServer.TickerStream do
  use GenServer

  alias WebServer.TickHandler

  # @market_client "http://market_client:5000"
  # @demo_fields "&field=4+10+11"

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    url = "market_client_demo:5020/quoteStream?symbol=AAPL"
    {:ok, HTTPoison.get!(url, %{}, [timeout: :infinity, stream_to: self()])}
  end

  def handle_info(msg, state) do
    parse_message(msg)
    {:noreply, state}
  end

  defp parse_message(%HTTPoison.AsyncChunk{chunk: chunk}) do
    TickHandler.parse(chunk)
  end

  defp parse_message(_), do: IO.puts("TickerStream unhandeled message")
end
