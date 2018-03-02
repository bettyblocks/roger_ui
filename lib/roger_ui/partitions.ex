defmodule RogerUI.Partitions do
  @moduledoc """
  Generate Partition list from Roger.Info.partitions()
  """
  @doc """
  `normalize/1` is a function that takes partitions as an input, partitions is a Keyword list that contains the nodes,
  status and partitions with queues, like this:

   [
    "server@127.0.0.1": %{
      running: %{
        "roger_test_partition_1" => %{
          default: %{consumer_count: 1, max_workers: 10, message_count: 740, paused: false},
          fast: %{consumer_count: 1, max_workers: 10, message_count: 740, paused: false},
          other: %{consumer_count: 1, max_workers: 2, message_count: 0, paused: false}
        }
      },...
    ]

  the function takes this input, captures  the values of the keyword list (node),  then transforms it into a new
  structure with the values needed.
  """
  def normalize(partitions) do
    partitions
    |> Enum.flat_map(&capture_node_name(&1))
  end

  defp capture_node_name({node_name, partitions}) do
    partitions
    |> Enum.flat_map(&normalize_partition(node_name, &1))
  end

  defp normalize_partition(node_name, {status, partitions}) do
    Enum.map(partitions, fn {partition_name, _} ->
        %{
          "node_name" => node_name,
          "status" => status,
          "partition_name" => partition_name
        }
    end)
  end
end
