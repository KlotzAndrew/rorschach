defmodule WebServer.QuoteStreamUrl do
  import Ecto.Query

  alias WebServer.Repo
  alias WebServer.Asset


  def url do
    tickers = Enum.join(tracking_assets(), "+")
    base_url = "http://market_client_demo:5020/quoteStream?symbol="

    base_url <> tickers
  end

  # TODO: this assumes all assets are tracked
  defp tracking_assets do
    query = from a in Asset, select: a.ticker

    Repo.all(query)
  end
end
