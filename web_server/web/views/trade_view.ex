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
      quantity: trade.quantity,
      price: trade.price}
  end

  def render("asset_holdings.json", %{holdings: holdings}) do
    %{data: render_many(holdings, WebServer.TradeView, "asset_holding.json", as: :holding)}
  end

  def render("asset_holding.json", %{holding: holding}) do
    {id, quantity} = holding
    %{
      id:       id,
      quantity: quantity
    }
  end
end
