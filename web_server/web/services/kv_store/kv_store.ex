defmodule KVStore do
  use Application

  def start(_type, _args) do
    KVStore.Supervisor.start_link
  end
end
