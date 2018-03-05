defmodule RogerUI.Queues do
  @moduledoc """
  Normalize queues from nodes
  """
  alias Roger.Queue

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

  and transforms it into a list of queues
  """

  def nodes_to_queues(nodes) do
    nodes
    |> Keyword.values()
    |> Stream.flat_map(&Map.values/1)
    |> Stream.flat_map(&partition_to_queues/1)
  end

  @doc """
  `normalize_name/1` is a function that verifies if its input (name) is an atom, if not, it is transformed into one
  """
  def normalize_name(name) do
    if is_atom(name), do: name, else: String.to_existing_atom(name)
  end

  defp normalize_queues({partition_name, queues}) do
    Stream.map(queues, fn {qn, queue} ->
      queue
      |> Map.put("qualified_queue_name", Queue.make_name(partition_name, qn))
      |> Map.put("queue_name", qn)
      |> Map.put("partition_name", partition_name)
    end)
  end

  defp partition_to_queues(partition), do: Stream.flat_map(partition, &normalize_queues/1)
end
