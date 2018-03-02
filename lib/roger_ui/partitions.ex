defmodule RogerUi.Partitions do
defmodule RogerUI.Partitions do
  @moduledoc """
  Generate Partition list from Roger.Info.partitions()
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
