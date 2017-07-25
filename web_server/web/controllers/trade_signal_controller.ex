defmodule WebServer.TradeSignalController do
  use WebServer.Web, :controller

  alias Court.{Registry, Judge}

  def index(conn, %{"portfolio_id" => portfolio_id}) do
    signals = fetch_signals(portfolio_id)
    data = %{
      signals: signals["signals"],
      created_at: signals["created_at"]
    }
    render(conn, "index.json-api", data: data)
  end

  defp fetch_signals(portfolio_id) do
    {id, _} = Integer.parse(portfolio_id)
    {_, judge} = Registry.find(id)
    Judge.signals(judge)
  end
end
