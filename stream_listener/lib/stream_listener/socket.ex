defmodule StreamListener.Socket do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    speak
  end

  defp speak do
    :timer.sleep(3000)
    IO.puts "StreamListener is running!"
    speak
  end
end
