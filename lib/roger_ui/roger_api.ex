defmodule RogerUi.RogerApi do
  @moduledoc """
  Api to calls Roger lib
  """

  @behaviour RogerUi.Roger

  def partitions(), do: Roger.Info.partitions()

  def purge_queue(partition_name, queue_name), do:
    Roger.Queue.purge(partition_name, queue_name)
end
