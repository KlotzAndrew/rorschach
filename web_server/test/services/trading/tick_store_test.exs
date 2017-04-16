defmodule TickStoreTest do
  use ExUnit.Case, async: true

  alias WebServer.{Tick, TickStore}

  defmodule Bucket do
    def put(:mock_bucket, "GOOG", _),
      do: send self(), :bucket_put
  end

  defmodule Registry do
    def create(_, _), do: :mock_bucket
  end

  test "stores tick changeset" do
    changeset = Tick.changeset(%Tick{
      asset_id:  1,
      ticker:    "GOOG",
      ask_price: Decimal.new(100),
    })
    TickStore.add(changeset, Registry, Bucket)

    assert_received :bucket_put
  end
end
