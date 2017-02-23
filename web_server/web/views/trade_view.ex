defmodule WebServer.TradeView do
  use WebServer.Web, :view

  def render("index.json", %{trades: trades}) do
    %{data: render_many(trades, WebServer.TradeView, "trade.json")}
  end

  def render("show.json", %{trade: trade}) do
    %{data: render_one(trade, WebServer.TradeView, "trade.json")}
  end

  def render("trade.json", %{trade: trade}) do
    %{id: trade.id,
      from_asset_id: trade.from_asset_id,
      to_asset_id: trade.to_asset_id,
      quantity: trade.quantity,
      price: trade.price}
  end
end
