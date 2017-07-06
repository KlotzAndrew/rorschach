defmodule AtClient.DayBars do
  use Timex

  alias WebServer.{AtClient}
  alias WebServer.{Repo, DayBar}

  def fetch(asset, days, repo \\ Repo, client \\ HTTPoison) do
    begin_time = get_begin(days)
    end_time = get_end(days)

    build_url(asset.ticker, begin_time, end_time)
      |> make_request(client)
      |> body_to_bars(asset)
      |> save_bars(repo)
  end

  defp save_bars(bars, repo) do
    Enum.map(bars, fn(b) -> repo.insert(b) end)
  end

  defp make_request(url, client) do
    client.get!(url).body
  end

  defp body_to_bars(body, asset) do
    String.split(body, "\r\n", trim: true)
      |> build_bars(asset)
  end

  defp build_bars(arr, asset) do
    Enum.reduce(arr, [], fn(str, acc) ->
      bar = parse_bar(str, asset)
      if bar, do: acc ++ [bar], else: acc
    end)
  end

  defp parse_bar(string, asset) do
    values = String.split(string, ",")

    DayBar.changeset(%DayBar{}, %{
      asset_id: asset.id,
      at_timestamp: AtClient.datetime(Enum.at(values, 0)),
      open_price: Decimal.new(Enum.at(values, 1)),
      high_price: Decimal.new(Enum.at(values, 2)),
      low_price: Decimal.new(Enum.at(values, 3)),
      close_price: Decimal.new(Enum.at(values, 4)),
      volume: Enum.at(values, 5)
    })
  end

  defp get_begin(days) do
    Timex.now("Canada/Eastern")
      |> Timex.shift(days: -days)
      |> string_time
  end

  defp get_end(_days) do
    Timex.now("Canada/Eastern")
      |> string_time
  end

  # YYYY_MM_DD_HH_MM_SS
  # 2017_07_04_00_00_00
  defp string_time(t) do
    "#{i_2(t.year)}#{i_2(t.month)}#{i_2(t.day)}000000"
  end

  defp i_2(int) when int < 10, do: "0#{int}"
  defp i_2(int), do: int

  defp build_url(ticker, begin_time, end_time) do
    "http://192.168.99.100:5000/barData?symbol=" <> ticker
      <> "&historyType=1&beginTime=" <> begin_time
      <> "&endTime=" <> end_time
  end
end
