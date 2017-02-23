defmodule WebServer.TickHandler do
  alias WebServer.Repo
  alias WebServer.Tick
  alias WebServer.Trader

  def parse(chunk, repo \\ Repo, trader \\ Trader) do
    tick_strings = String.split(chunk, "\n", trim: true)
    Enum.each tick_strings, fn string -> parse_tick(string, repo, trader) end
  end

  defp parse_tick(string, repo, trader) do
    values = String.split(string, ",")
    if Enum.at(values, 0) == "Q" do
      changeset = build_tick(values)

      trader.trade(changeset)
      save_tick(changeset, repo)
    end
  end

  defp build_tick(tick) do
    Tick.changeset(%Tick{
      type: Enum.at(tick, 0),
      asset_id: 1,
      quote_condition: str_to_int(Enum.at(tick, 2)),
      bid_exchange: Enum.at(tick, 3),
      ask_exchange: Enum.at(tick, 4),
      bid_price: Decimal.new(Enum.at(tick, 5)),
      ask_price: Decimal.new(Enum.at(tick, 6)),
      bid_size: Decimal.new(Enum.at(tick, 7)),
      ask_size: Decimal.new(Enum.at(tick, 8)),
      time: datetime(Enum.at(tick, 9))
    })
  end

  defp save_tick(changeset, repo) do
    repo.insert!(changeset)
  end

  defp str_to_int(string) do
    {value, _} = Integer.parse(string)
    value
  end

  # YYYY_MM_DD_HH_MM_SS_mmm
  # 2017_02_15_12_54_26_269
  defp datetime(string) do
    {_status, time} = Ecto.DateTime.cast(%{
      year: String.slice(string, 0..3),
      month: String.slice(string, 4..5),
      day: String.slice(string, 6..7),
      hour: String.slice(string, 8..9),
      minute: String.slice(string, 10..11),
      second: String.slice(string, 12..13),
      microsecond: String.slice(string, 14..16) <> "000",
    })
    time
  end
end
