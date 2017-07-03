defmodule Court.Registry do
  use GenServer

  alias Court.{Registry, Judge}

  @table :judge_registry

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def add(id, pid) do
    GenServer.call(__MODULE__, {:add, id, pid})
  end

  def find(id, judge \\ Judge) do
    result_set = GenServer.call(__MODULE__, {:find, id})
    result = Enum.at(result_set, 0)

    if result == nil do
      judge.start_link(id)
      result = Registry.find(id)
    end

    result
  end

  # Callbacks
  def init(_opts) do
    :ets.new(@table, [:named_table, read_concurrency: true])

    {:ok, []}
  end

  def handle_call({:add, id, pid}, _from, state) do
    inserted = :ets.insert(@table, {id, pid})

    {:reply, inserted, state}
  end

  def handle_call({:find, id}, _from, state) do
    result = :ets.lookup(@table, id)

    {:reply, result, state}
  end
end
