defmodule WebServer.TickView do
  use WebServer.Web, :view

  def render("index.json", %{ticks: ticks}) do
    %{data: render_many(ticks, WebServer.TickView, "tick.json")}
  end

  def render("show.json", %{tick: tick}) do
    %{data: render_one(tick, WebServer.TickView, "tick.json")}
  end

  def render("tick.json", %{tick: tick}) do
    %{
      id: tick.id,
      type: tick.type,
      asset_id: tick.asset_id,
      quote_condition: tick.quote_condition,
      bid_exchange: tick.bid_exchange,
      ask_exchange: tick.ask_exchange,
      bid_price: tick.bid_price,
      ask_price: tick.ask_price,
      bid_size: tick.bid_size,
      ask_size: tick.ask_size,
      time: tick.time
    }
  end
end
