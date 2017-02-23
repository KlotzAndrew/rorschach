defmodule WebServer.TickerStream do
  require Logger
  use GenServer

  alias WebServer.TickHandler
  alias WebServer.QuoteStreamUrl

  # @market_client "http://market_client:5000"
  # @demo_fields "&field=4+10+11"

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    url = QuoteStreamUrl.url
    {:ok, HTTPoison.get!(url, %{}, [timeout: :infinity, recv_timeout: :infinity, stream_to: self()])}
  end

  def handle_info(msg, state) do
    parse_message(msg)
    {:noreply, state}
  end

  defp parse_message(%HTTPoison.AsyncChunk{chunk: chunk}) do
    Logger.info "AsyncChunk: #{chunk}"
    TickHandler.parse(chunk)
  end

  defp parse_message(%HTTPoison.AsyncStatus{code: code}) do
    Logger.info "AsyncStatus: #{code}"
  end

  defp parse_message(%HTTPoison.AsyncHeaders{headers: headers}) do
    Logger.info "AsyncHeaders: #{headers}"
  end

  defp parse_message(%HTTPoison.Error{reason: reason}) do
    Logger.info "Error: #{reason}"
  end

  defp parse_message(msg), do: IO.puts(msg)
end
