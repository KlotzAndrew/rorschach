defmodule WebServer.TickerStream do
  require Logger
  use GenServer

  alias WebServer.{TickHandler, QuoteStreamUrl}

  # @market_client "http://market_client:5000"
  # @demo_fields "&field=4+10+11"

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    url = QuoteStreamUrl.url
    {:ok, HTTPoison.get!(url, %{}, [timeout: :infinity, stream_to: self()])}
  end

  def handle_info(msg, state) do
    parse_message(msg)
    {:noreply, state}
  end

  defp parse_message(%HTTPoison.AsyncChunk{chunk: chunk}) do
    Logger.info "AsyncChunk: #{chunk}"
    TickHandler.parse(chunk)
  end

  defp parse_message(%HTTPoison.AsyncStatus{code: _code}) do
    Logger.info "AsyncStatus: ---"
  end

  defp parse_message(%HTTPoison.AsyncHeaders{headers: _headers}) do
    Logger.info "AsyncHeaders: ---"
  end

  defp parse_message(%HTTPoison.Error{reason: _reason}) do
    Logger.info "HTTPoison.Error: ---"
  end

  defp parse_message(_msg), do: IO.puts("TickerStream unhandeled message")
end
