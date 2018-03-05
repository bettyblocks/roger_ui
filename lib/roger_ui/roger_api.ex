defmodule RogerUi.RogerApi do
  @moduledoc """
  Api to calls Roger lib
  """

  @behaviour RogerUi.Roger
  alias Roger.{Info, Job, Partition, Queue, AMQPClient}
  alias AMQP.Basic

  defdelegate purge_queue(partition_name, queue_name), to: Queue, as: :purge
  defdelegate queue_pause(partition_name, queue_name), to: Partition.Global
  defdelegate queue_resume(partition_name, queue_name), to: Partition.Global
  defdelegate cancel_job(partition_name, queue_name), to: Partition.Global
  defdelegate partitions, to: Info
  defdelegate running_jobs(), to: Info
  defdelegate running_jobs(partition_name), to: Info
  defdelegate queued_jobs(partition_name, queue_name, count \\ 1_000_000), to: Info
end
