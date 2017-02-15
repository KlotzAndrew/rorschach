defmodule WebServer.TickView do
  use WebServer.Web, :view

  def render("index.json", %{ticks: ticks}) do
    %{data: render_many(ticks, WebServer.TickView, "tick.json")}
  end

  def render("show.json", %{tick: tick}) do
    %{data: render_one(tick, WebServer.TickView, "tick.json")}
  end

  def render("tick.json", %{tick: tick}) do
    %{id: tick.id,
      name: tick.name,
      asset_id: tick.asset_id,
      price: tick.price}
  end
end
