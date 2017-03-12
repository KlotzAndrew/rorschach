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

  def render("asset_sums.json", %{sums: sums}) do
    %{data: render_many(sums, WebServer.TradeView, "asset_sum.json", as: :sum)}
  end

  def render("asset_sum.json", %{sum: sum}) do
    {id, quantity} = sum
    %{
      id:       id,
      quantity: quantity
    }
  end
end
