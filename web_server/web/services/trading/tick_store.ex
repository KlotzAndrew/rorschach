defmodule WebServer.TickStore do
  alias KVStore.{Registry, Bucket}

  def add(tick_changeset, registry \\ Registry, bucket \\ Bucket) do
    ticker_bucket = registry.create(registry, "tickers")

    bucket.put(ticker_bucket, tick_changeset.data.ticker, tick_changeset)
  end

  def get(tick_changeset, registry \\ Registry, bucket \\ Bucket) do
    ticker_bucket = registry.create(registry, "tickers")

    bucket.get(ticker_bucket, tick_changeset.data.ticker)
  end
end
