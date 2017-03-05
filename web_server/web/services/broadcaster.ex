defmodule WebServer.Broadcaster do
  alias WebServer.Endpoint

  def broadcast_trade(trade, endpoint \\ Endpoint) do
    payload = payload(trade)
    endpoint.broadcast! "room:lobby", "new:trade", payload
  end

  def broadcast_trades(trades, endpoint \\ Endpoint) do
    Enum.each(trades, fn t -> broadcast_trade(t, endpoint) end)
  end

  defp payload(trade) do
    %{
      "id" => trade.id,
      "price" => trade.price,
      "quantity" => trade.quantity,
      "portfolio_id" => trade.portfolio_id,
      "from_asset_id" => trade.from_asset_id,
      "to_asset_id" => trade.to_asset_id
    }
  end
end
