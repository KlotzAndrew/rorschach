defmodule Court.Arbiter do
  def decide(all_signals, tick) do
    signals = all_signals[tick.ticker]
    calc(signals, tick)
  end

  def new_trade_info(all_signals, trade, tick) do
    put_in(
      all_signals,
      [tick.ticker, "traded"], trade.quantity > 0
    )
  end

  defp calc(nil, _tick), do: nil
  defp calc(%{"enter" => nil, "exit" => _ex, "traded" => _tr}, _tick), do: nil
  defp calc(%{"enter" => _ent, "exit" => nil, "traded" => _tr}, _tick), do: nil
  defp calc(%{"enter" => nil, "exit" => nil, "traded" => _tr}, _tick), do: nil
  defp calc(%{"enter" => _ent, "exit" => _ex, "traded" => true}, _tick), do: nil

  defp calc(%{"enter" => ent, "exit" => ex, "traded" => _tr}, tick) do
    cond do
      tick.ask_price < ent -> {:buy, 1}
      tick.ask_price > ex -> {:sell, -1}
    end
  end
end
