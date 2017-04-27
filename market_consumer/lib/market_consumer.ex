defmodule MC do
  use Application
  @moduledoc """
  Documentation for MC.
  """

  @doc """
  Hello world.

  ## Examples

      iex> MC.hello
      :world

  """
  def hello do
    :world
  end

  def start(_type, _args) do
    MC.Supervisor.start_link
  end
end
