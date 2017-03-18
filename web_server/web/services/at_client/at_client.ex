defmodule WebServer.AtClient do

  alias WebServer.{Tick}

  def streaming_url(tickers) do
    base_url = "http://market_client_demo:5020/quoteStream?symbol="

    base_url <> Enum.join(tickers, "+")
  end

  def build_tick(tick_values) do
    Tick.changeset(%Tick{
      asset_id:        1,
      type:            Enum.at(tick_values, 0),
      ticker:          Enum.at(tick_values, 1),
      quote_condition: str_to_int(Enum.at(tick_values, 2)),
      bid_exchange:    Enum.at(tick_values, 3),
      ask_exchange:    Enum.at(tick_values, 4),
      bid_price:       Decimal.new(Enum.at(tick_values, 5)),
      ask_price:       Decimal.new(Enum.at(tick_values, 6)),
      bid_size:        Decimal.new(Enum.at(tick_values, 7)),
      ask_size:        Decimal.new(Enum.at(tick_values, 8)),
      time:            datetime(Enum.at(tick_values, 9))
    })
  end

  # YYYY_MM_DD_HH_MM_SS_mmm
  # 2017_02_15_12_54_26_269
  defp datetime(string) do
    {_status, time} = Ecto.DateTime.cast(%{
      year:        String.slice(string, 0..3),
      month:       String.slice(string, 4..5),
      day:         String.slice(string, 6..7),
      hour:        String.slice(string, 8..9),
      minute:      String.slice(string, 10..11),
      second:      String.slice(string, 12..13),
      microsecond: String.slice(string, 14..16) <> "000",
    })
    time
  end

  defp str_to_int(string) do
    {value, _} = Integer.parse(string)
    value
  end
end
