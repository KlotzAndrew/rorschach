defmodule KVStore.RegistryTest do
  use ExUnit.Case, async: true

  setup context do
    {:ok, _} = KVStore.Registry.start_link(context.test)
    {:ok, registry: context.test}
  end

  test "spawns buckets", %{registry: registry} do
    assert KVStore.Registry.lookup(registry, "tickers") == :error

    KVStore.Registry.create(registry, "tickers")
    assert {:ok, bucket} = KVStore.Registry.lookup(registry, "tickers")

    KVStore.Bucket.put(bucket, "NFLX", 1)
    assert KVStore.Bucket.get(bucket, "NFLX") == [1]
  end

  test "removes buckets on exit", %{registry: registry} do
    KVStore.Registry.create(registry, "tickers")
    {:ok, bucket} = KVStore.Registry.lookup(registry, "tickers")
    Agent.stop(bucket)

    _ = KVStore.Registry.create(registry, "bogus")
    assert KVStore.Registry.lookup(registry, "tickers") == :error
  end

  test "removes bucket on crash", %{registry: registry} do
    KVStore.Registry.create(registry, "tickers")
    {:ok, bucket} = KVStore.Registry.lookup(registry, "tickers")

    # Stop the bucket with non-normal reason
    ref = Process.monitor(bucket)
    Process.exit(bucket, :shutdown)

    # Wait until the bucket is dead
    assert_receive {:DOWN, ^ref, _, _, _}

    _ = KVStore.Registry.create(registry, "bogus")
    assert KVStore.Registry.lookup(registry, "tickers") == :error
  end
end
