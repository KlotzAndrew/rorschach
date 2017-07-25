defmodule WebServer.TradeSignalView do
  use WebServer.Web, :view
  use JaSerializer.PhoenixView

  attributes [:created_at, :signals]
end
