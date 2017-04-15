defmodule KVStore.Bucket do
  @max_ticks 1000
  @doc """
  Starts a new bucket.
  """
  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Gets a value from the `bucket` by `key`.
  """
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @doc """
  Puts the `value` for the given `key` in the `bucket`.
  """
  def put(bucket, key, value) do
    Agent.get_and_update(bucket, fn dict ->
      ticks       = Map.get(dict, key, [])
      added_ticks = ticks ++ [value]

      new_ticks =
        if Enum.count(added_ticks) > @max_ticks,
          do:   List.delete_at(added_ticks, 0),
          else: added_ticks

      {:ok, Map.put(dict, key, new_ticks)}
    end)
  end

  @doc """
  Deletes `key` from `bucket`.

  Returns the current value of `key`, if `key` exists.
  """
  def delete(bucket, key) do
    Agent.get_and_update(bucket, fn dict ->
      Map.pop(dict, key)
    end)
  end
end
