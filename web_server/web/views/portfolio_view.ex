defmodule WebServer.PortfolioView do
  use WebServer.Web, :view

  def render("index.json", %{portfolios: portfolios}) do
    %{data: render_many(portfolios, WebServer.PortfolioView, "portfolio.json")}
  end

  def render("show.json", %{portfolio: portfolio}) do
    %{data: render_one(portfolio, WebServer.PortfolioView, "portfolio.json")}
  end

  def render("portfolio.json", %{portfolio: portfolio}) do
    %{id: portfolio.id,
      name: portfolio.name}
  end
end
