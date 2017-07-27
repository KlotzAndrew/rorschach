defmodule WebServer.PortfolioRepository do
  # import Ecto.Query
  alias WebServer.{Portfolio, Repo}

  def all do
    Repo.all(Portfolio)
  end
end
