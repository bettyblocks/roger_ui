defmodule RogerUI.Partitions do
  @moduledoc """
  Generate Partition list from Roger.Info.partitions()
  """
  @doc """
  Takes a Keyword list that contains the nodes, status and partitions with queues, like this:

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

  and transforms it into a partition list
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
