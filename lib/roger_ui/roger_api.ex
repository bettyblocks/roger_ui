defmodule RogerUI.RogerApi do
  @moduledoc """
  Implements RogerUI.Roger behaviour, delegating on Roger API
  """

  @behaviour RogerUI.Roger
  alias Roger.{Info, Partition, Queue}

  defdelegate purge_queue(partition_name, queue_name), to: Queue, as: :purge
  defdelegate queue_pause(partition_name, queue_name), to: Partition.Global
  defdelegate queue_resume(partition_name, queue_name), to: Partition.Global
  defdelegate cancel_job(partition_name, queue_name), to: Partition.Global
  defdelegate partitions, to: Info
  defdelegate running_jobs(), to: Info
  defdelegate running_jobs(partition_name), to: Info
  defdelegate queued_jobs(partition_name, queue_name, count \\ 1000), to: Info
end
