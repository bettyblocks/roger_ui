defmodule RogerUi.Roger do
  @moduledoc """
  Contract to Roger calls
  """

  @type queue :: %{
    consumer_count: integer(),
    max_workers: integer(),
    message_count: integer(),
    paused: boolean()
  }
  @type queues :: %{atom() => queue()}
  @type partitions :: %{required(String.t()) => queues()} | %{}
  @type nodes :: keyword(%{running: partitions(), waiting: partitions()})

  @callback partitions :: nodes()
end
