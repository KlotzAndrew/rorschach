defmodule WebServer.Random do
  def calculate_trade(_, _, _, roll \\ :rand.uniform(4)) do
    case roll do
      1 -> {:buy, 1}
      2 -> {:sell, -1}
      _ -> nil
    end
  end
end
