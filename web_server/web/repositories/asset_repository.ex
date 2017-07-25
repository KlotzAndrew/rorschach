defmodule WebServer.AssetRepository do
  import Ecto.Query
  alias WebServer.{Asset, Repo}

  def all_non_cash do
    query = from a in Asset, where: a.ticker != "CASH:USD"
    Repo.all(query)
  end
end
