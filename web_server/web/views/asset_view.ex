defmodule WebServer.AssetView do
  use WebServer.Web, :view

  def render("index.json", %{assets: assets}) do
    %{data: render_many(assets, WebServer.AssetView, "asset.json")}
  end

  def render("show.json", %{asset: asset}) do
    %{data: render_one(asset, WebServer.AssetView, "asset.json")}
  end

  def render("asset.json", %{asset: asset}) do
    %{id: asset.id,
      name: asset.name,
      ticker: asset.ticker,
      exchange: asset.exchange}
  end
end
