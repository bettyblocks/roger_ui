defmodule RogerUi.Jobs do
defmodule RogerUI.Jobs do
  @moduledoc """
  Generate Jobs list from Roger.Info.running_jobs()
  """

  @doc """
  `normalize/1` is a function that takes jobs as an input, job is a Keyword list that contains the nodes,
  partitions and jobs like this:

  [
      "watcher@127.0.0.1": %{
         "roger_demo_partition" => [
            %Roger.Job{
              args: %{"country" => "Venezuela", "email" => "janedoe@gmail.com", "name" => "Jane Doe",
              "number_of_pets" => 966},execution_key: nil, id: "16ovjr39jvijf4kgrlqe2ib2aadojhid",
              module: RogerDemo.Job.CreateUpdateUser,queue_key: nil, queued_at: 1517697586453,
              retry_count: 0,started_at: 1517697682999
            },
  ]...

  the function takes this input, extract the values of the keyword list and then transforms the results into
  a new list of jobs with the partition name in it.
  """

  def normalize(jobs) do
    jobs
    |> Keyword.values()
    |> Stream.flat_map(&partition_to_jobs/1)
  end

  defp partition_to_jobs(partition), do: Stream.flat_map(partition, &normalize_jobs/1)

  defp normalize_jobs({partition_name, jobs}) do
    Stream.map(jobs, fn job ->
      job
      |> Map.from_struct()
      |> Map.put("partition_name", partition_name)
    end)
  end
end
