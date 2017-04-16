defmodule KVStore.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = KVStore.Bucket.start_link
    {:ok, bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert KVStore.Bucket.get(bucket, "NFLX") == nil

    KVStore.Bucket.put(bucket, "NFLX", 3)
    assert KVStore.Bucket.get(bucket, "NFLX") == [3]
  end

  test "inserts value at end of list", %{bucket: bucket} do
    assert KVStore.Bucket.get(bucket, "NFLX") == nil

    KVStore.Bucket.put(bucket, "NFLX", 3)
    KVStore.Bucket.put(bucket, "NFLX", 4)
    KVStore.Bucket.put(bucket, "NFLX", 5)
    assert KVStore.Bucket.get(bucket, "NFLX") == [3, 4, 5]
  end

  test "keeps list under max size", %{bucket: bucket} do
    assert KVStore.Bucket.get(bucket, "NFLX") == nil

    for x <- 0..1000, do: KVStore.Bucket.put(bucket, "NFLX", x)

    ticks = KVStore.Bucket.get(bucket, "NFLX")
    assert Enum.count(ticks) == 1000
    assert Enum.at(ticks, 0) == 1

    KVStore.Bucket.put(bucket, "NFLX", 3)

    ticks = KVStore.Bucket.get(bucket, "NFLX")
    assert Enum.count(ticks) == 1000
    assert Enum.at(ticks, 0) == 2
  end
end
