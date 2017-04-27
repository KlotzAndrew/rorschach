defmodule WebServer.AssetFetcher do
  alias WebServer.Repo
  alias WebServer.Asset

  def get_by_ticker(ticker, repo \\ Repo) do
    asset = repo.get_by(Asset, %{ticker: ticker})

    return_asset(asset, ticker)
  end

  defp return_asset(asset, ticker) when asset == nil, do: fetch_asset(ticker)
  defp return_asset(asset, _ticker), do: asset

  # TSLA,1,33,1,8,Tesla Motors, Inc.\r\n
  defp fetch_asset(ticker) do
    response = request_asset(ticker)
    body = String.split(response.body, "\r\n", trim: true)

    save_asset(Enum.at(body, 0))
  end

  # TODO: getting attrs should probably be a queue to avoid ugliness. will be
  # unstable if if more attrs are added
  defp save_asset(body) do
    string    = String.split(body, ",")
    changeset = Asset.changeset(%Asset{
      ticker: Enum.at(string, 0),
      name:   name(string)
    })
    Repo.insert!(changeset)
  end

  defp name(string) do
    name_parts = Enum.slice(string, 5, Enum.count(string) -1)
    Enum.join(name_parts, ",")
  end

  defp request_asset(ticker) do
    url_base = "http://market:5000/quoteData?symbol="
    fields   = "&field=33"
    url      = url_base <> ticker <> fields

    HTTPoison.get!(url)
  end
end
