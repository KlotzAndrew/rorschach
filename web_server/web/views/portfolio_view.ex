defmodule WebServer.PortfolioView do
  use WebServer.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :id]
end
