defmodule Court.Arbiter do
  def decide(all_signals, _tick) when all_signals == %{} do
    %{decision: nil, signals: all_signals}
  end
  def decide(all_signals, tick) do
    signals = all_signals[tick.ticker]
    decision = calc(signals, tick)
    %{decision: decision, signals: update_signals(decision, all_signals, tick)}
  end

  def new_trade_info(all_signals, trade, tick) do
    put_in(
      all_signals,
      [tick.ticker, "traded"], trade.quantity > 0
    )
  end

  defp update_signals(nil, all_signals, _tick), do: all_signals
  defp update_signals(decision, all_signals, tick) do
    ticker = tick.ticker
    all_signals
      |> put_in([ticker, "traded"], traded_value(decision))
      |> put_in([ticker, "quantity"], new_quantity(all_signals, ticker, decision))
  end

  defp new_quantity(all_signals, ticker, {_type, q}) do
    get_in(all_signals, [ticker, "quantity"]) + q
  end

  defp traded_value({:buy, _q}), do: true
  defp traded_value({:sell, _q}), do: false

  defp calc(nil, _tick), do: nil
  defp calc(%{"enter" => nil, "exit" => _ex, "traded" => _tr}, _tick), do: nil
  defp calc(%{"enter" => _ent, "exit" => nil, "traded" => _tr}, _tick), do: nil
  defp calc(%{"enter" => nil, "exit" => nil, "traded" => _tr}, _tick), do: nil
  defp calc(%{"enter" => ent, "exit" => _ex, "traded" => _tr, "quantity" => 0}, tick) do
    cond do
      lt?(tick.ask_price, ent) -> {:buy, 1}
      true -> nil
    end
  end
  defp calc(%{"enter" => _ent, "exit" => ex, "traded" => true}, tick) do
    cond do
      gt?(tick.ask_price, ex) -> {:sell, -1}
      true -> nil
    end
  end
  defp calc(%{"enter" => ent, "exit" => ex, "traded" => _tr}, tick) do
    cond do
      gt?(tick.ask_price, ex) -> {:sell, -1}
      lt?(tick.ask_price, ent) -> {:buy, 1}
      true -> nil
    end
  end

  defp lt?(left, right) do
    case Decimal.cmp(left, right) do
      :lt -> true
      _ -> false
    end
  end

  defp gt?(left, right) do
    case Decimal.cmp(left, right) do
      :gt -> true
      _ -> false
    end
  end
end
