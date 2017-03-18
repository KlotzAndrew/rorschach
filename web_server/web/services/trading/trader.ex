defmodule WebServer.Trader do
  alias WebServer.{Broker}

  def trade(changeset, broker \\ Broker, roll \\ :rand.uniform(4)) do
    case roll do
      1 -> broker.buy_stock(changeset)
      2 -> broker.sell_stock(changeset)
      _ -> []
    end
  end
end
