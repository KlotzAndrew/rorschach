defmodule WebServer.QuoteStreamUrl do
  import Ecto.Query

  alias WebServer.{Asset, AtClient, Repo}

  def url(client \\ AtClient) do
    client.streaming_url(tracking_tickers())
  end

  # TODO: this assumes all assets are tracked
  # TODO: figure out how to handle cash equity pricing
  defp tracking_tickers do
    query = from a in Asset,
            where: a.ticker != "CASH:USD",
            select: a.ticker

    Repo.all(query)
  end
end
