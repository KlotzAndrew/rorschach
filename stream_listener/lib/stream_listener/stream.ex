defmodule StreamListener.Stream do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, HTTPoison.get(url(), %{}, [timeout: :infinity, stream_to: self()])}
  end

  defp url do
    "http://market_client_demo:5020/quoteStream?symbol=NFLX+AMZN"
  end

  def handle_info(msg, state) do
    parse_message(msg)
    {:noreply, state}
  end

  defp parse_message(%HTTPoison.AsyncChunk{chunk: chunk}) do
    IO.puts "AsyncChunk: "
    IO.inspect chunk
  end

  defp parse_message(%HTTPoison.AsyncStatus{code: code}) do
    IO.puts "AsyncStatus: ---"
    IO.inspect code
  end

  defp parse_message(%HTTPoison.AsyncHeaders{headers: headers}) do
    IO.puts "AsyncHeaders: ---"
    IO.inspect headers
  end

  defp parse_message(%HTTPoison.Error{reason: reason}) do
    IO.puts "HTTPoison.Error: ---"
    IO.inspect reason
  end

  defp parse_message(_msg), do: IO.puts("TickerStream unhandeled message")
end
