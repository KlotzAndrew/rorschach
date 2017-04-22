defmodule StreamListener do
  use Application
  @moduledoc """
  Documentation for StreamListener.
  """

  @doc """
  Hello world.

  ## Examples

      iex> StreamListener.hello
      :world

  """
  def hello do
    :world
  end

  def start(_type, _args) do
    StreamListener.Supervisor.start_link
  end
end
