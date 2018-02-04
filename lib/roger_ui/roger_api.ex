defmodule RogerUi.RogerApi do
  @moduledoc """
  Api to calls Roger lib
  """

  @behaviour RogerUi.Roger

  def partitions(), do: Roger.Info.partitions()

  def purge_queue(partition_name, queue_name), do:
    Roger.Queue.purge(partition_name, queue_name)

  def queue_pause(partition_name, queue_name), do:
    Roger.Partition.Global.queue_pause(partition_name, queue_name)

  def queue_resume(partition_name, queue_name), do:
    Roger.Partition.Global.queue_resume(partition_name, queue_name)

  def cancel_job(partition_name, job_name), do:
    Roger.Partition.Global.cancel_job(partition_name, job_name)

  def running_jobs(partition_name), do: Roger.Info.running_jobs(partition_name)

  def queued_jobs(partition_name, queue_name, count \\ 100), do:
      Roger.Info.queued_jobs(partition_name, queue_name, count)
end
