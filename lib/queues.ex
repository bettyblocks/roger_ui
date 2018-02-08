defmodule RogerUi.Queues do
  @moduledoc """
  Normalize queues from nodes
  """
  alias Roger.Queue

  defp named_queues(partition_name, queues) do
    Enum.map(queues, fn {qn, queue} ->
      queue
      |> Map.put("qualified_queue_name", Queue.make_name(partition_name, qn))
      |> Map.put("queue_name", qn)
      |> Map.put("partition_name", partition_name)
    end)
  end

  def nodes_to_queues(nodes) do
    nodes
    |> Keyword.values()
    |> Stream.flat_map(&Map.values/1)
    |> Enum.reduce(%{}, &(Map.merge(&2, &1)))
    |> Enum.flat_map(fn {pn, q} -> named_queues(pn, q) end)
  end

  def atom_name(name) do
    if is_atom(name), do: name, else: String.to_atom(name)
  end
end
