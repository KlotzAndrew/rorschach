defmodule Court.Arbiter do
  def decide(all_signals, tick_cs) do
    signals = all_signals[tick_cs.params["ticker"]]
    calc(signals, tick_cs)
  end

  def new_trade_info(all_signals, trade, tick_cs) do
    put_in(
      all_signals,
      [tick_cs.params["ticker"], "traded"], trade.quantity > 0
    )
  end

  defp calc(nil, _tick_cs), do: nil
  defp calc(%{"enter" => nil, "exit" => _ex, "traded" => _tr}, _tick_cs), do: nil
  defp calc(%{"enter" => _ent, "exit" => nil, "traded" => _tr}, _tick_cs), do: nil
  defp calc(%{"enter" => nil, "exit" => nil, "traded" => _tr}, _tick_cs), do: nil
  defp calc(%{"enter" => _ent, "exit" => _ex, "traded" => true}, _tick_cs), do: nil

  defp calc(%{"enter" => ent, "exit" => ex, "traded" => _tr}, tick_cs) do
    cond do
      tick_cs.params["ask_price"] < ent -> {:buy, 1}
      tick_cs.params["ask_price"] > ex -> {:sell, -1}
    end
  end
end
