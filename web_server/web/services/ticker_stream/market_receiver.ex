defmodule WebServer.MarketReceiver do
  use GenServer

  alias WebServer.{TickHandler}

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def handle_info(msg, state) do
    parse_message(msg)
    {:noreply, state}
  end

  defp parse_message(%HTTPoison.AsyncChunk{chunk: chunk}) do
    TickHandler.parse(chunk)
  end

  defp parse_message(%HTTPoison.AsyncStatus{code: code}) do
    IO.inspect code, label: "AsyncStatus: "
  end

  defp parse_message(%HTTPoison.AsyncHeaders{headers: headers}) do
    IO.inspect headers, label: "AsyncHeaders: "
  end

  defp parse_message(%HTTPoison.Error{reason: reason}) do
    IO.inspect reason, label: "HTTPoison.Error: "
  end

  defp parse_message(msg) do
    IO.inspect msg, label: "HTTPoison unhandeled message: "
  end
end
