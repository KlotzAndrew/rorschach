defmodule Court.RegistryTest do
  use ExUnit.Case, async: true

  defmodule MockJudgeSupervisor do
    def start_judge(id) do
      {id, "pid"}
    end
  end

  test "find returns existing judge" do
    id = 1
    pid = "some pid!"
    Court.Registry.add(id, pid)

    assert Court.Registry.find(id) == {id, pid}
  end

  test "find adds judge" do
    id = 2
    {return_id, _pid} = Court.Registry.find(id, MockJudgeSupervisor)

    assert return_id == id
  end
end
