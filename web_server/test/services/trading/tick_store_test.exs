defmodule TickStoreTest do
  use ExUnit.Case, async: true

  alias WebServer.{Tick, TickStore}

  defmodule Bucket do
    def put(:mock_bucket, "GOOG", _),
      do: send self(), :bucket_put

    def get(:mock_bucket, "GOOG"), do: [1, 2, 3]
  end

  defmodule Registry do
    def create(_, _), do: :mock_bucket
  end

  test ".add stores tick changeset" do
    changeset = Tick.changeset(%Tick{
      asset_id:  1,
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    })
    TickStore.add(changeset, Registry, Bucket)

    assert_received :bucket_put
  end

  test ".get returns ticks" do
    changeset = Tick.changeset(%Tick{
      asset_id:  1,
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    })
    result = TickStore.get(changeset, Registry, Bucket)

    assert result == [1, 2, 3]
  end
end
