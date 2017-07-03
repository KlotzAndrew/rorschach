defmodule Court.RegistryTest do
  use ExUnit.Case, async: true

  test "find returns existing judge" do
    id = 1
    pid = "some pid!"
    Court.Registry.add(id, pid)

    assert Court.Registry.find(id) == {id, pid}
  end

  test "find adds judge" do
    id = 2
    assert Court.Registry.find(id) == "idk"
  end
end
