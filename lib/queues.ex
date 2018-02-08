defmodule RogerUi.Queues do
  @moduledoc """
  Normalize queues from nodes
  """

  defp reduce_queue(partition, f) do
    partition
    |> Map.keys()
    |> Enum.reduce([], fn k, l -> [f.(partition, k) | l] end)
  end

  defp named_queues(partition, name) do
    queues = partition[name]

    queues
    |> Map.keys()
    |> Enum.map(fn qn ->
      %{
        "qualified_queue_name" => Roger.Queue.make_name(name, qn),
        "queue_name" => qn,
        "partition_name" => name,
        "paused" => if(partition[name][qn].paused, do: "paused", else: "running"),
        "count" => partition[name][qn].message_count
      }
    end)
  end

  defp queues_partition(partitions, name) do
    reduce_queue(partitions[name], &named_queues/2)
  end

  defp extract_queues(node) do
    reduce_queue(elem(node, 1), &queues_partition/2)
  end

  def filter(nodes, filter) do
    queues =
      nodes
      |> Enum.map(fn node -> extract_queues(node) end)
      |> List.flatten()

    do_fiter(queues, filter)
  end

  defp do_fiter(queues, ""), do: queues
  defp do_fiter(queues, filter) do
    Enum.filter(queues, fn q ->
      q["qualified_queue_name"] |> String.upcase() |> String.contains?(filter)
    end)
  end

  def atom_name(name) do
    if is_atom(name), do: name, else: String.to_atom(name)
  end
end
