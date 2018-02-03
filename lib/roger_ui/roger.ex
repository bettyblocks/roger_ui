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

  @doc """
  Retrieve combined partition info on all running and waiting partitions, over the entire cluster.
  """
  @callback partitions :: nodes()

  @doc """
  Flushes all messages on the given queue
  """
  @callback purge_queue(String.t(), atom()) :: {:ok, %{message_count: integer()}}
end
