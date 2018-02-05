defmodule RogerUi.Web.QueuesPlug do
  @moduledoc """
  Endpoints to process queues api calls
  """

  require Logger
  alias RogerUi.Web.QueuesPlug.Router

  def init(opts), do: opts

  def call(conn, opts) do
    Router.call(conn, Router.init(opts))
  end

  defmodule Router do
    @moduledoc """
    Plug Router extension for QueuesPlug
    """

    @roger_api Application.get_env(:roger_ui, :roger_api, RogerUi.RogerApi)

    import Plug.Conn
    import RogerUi.Web.ResponseHelper
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    defp named_queues(partition, name) do
      queues = partition[name]

      queues
      |> Map.keys()
      |> Enum.map(fn qn ->
        %{
          qualified_queue_name: Roger.Queue.make_name(name, qn),
          queue_name: qn,
          partition_name: name,
          paused: if(partition[name][qn].paused, do: "paused", else: "running"),
          count: partition[name][qn].message_count
        }
      end)
    end

    defp queues_partition(partitions, name) do
      partition = partitions[name]

      partition
      |> Map.keys()
      |> Enum.reduce([], fn k, l -> [named_queues(partition, k) | l] end)
    end

    defp extract_queues(node) do
      partitions = elem(node, 1)

      partitions
      |> Map.keys()
      |> Enum.reduce([], fn k, l -> [queues_partition(partitions, k) | l] end)
    end

    def filtered_queues(nodes, filter) do
      queues =
        nodes
        |> Enum.map(fn node -> extract_queues(node) end)
        |> List.flatten()

      if filter == "" do
        queues
      else
        Enum.filter(queues, fn q -> String.contains?(q.qualified_queue_name, filter) end)
      end
    end

    def paginated_queues(nodes, page_size, page_number, filter \\ "") do
      page_size = if page_size > 100, do: 100, else: page_size
      queues =  filtered_queues(nodes, filter)

      %{queues: Enum.slice(queues, page_size * (page_number - 1), page_size),
        total: Enum.count(queues)}
    end

    def pause_queue(q) do
      name = if is_atom(q.queue_name), do: q.queue_name, else: String.to_atom(q.queue_name)
      @roger_api.queue_pause(q.partition_name, name)
    end

    get "/:page_size/:page_number" do
      conn = fetch_query_params(conn)
      page_size = String.to_integer(page_size)
      page_number = String.to_integer(page_number)
      filter = Map.get(conn.query_params, "filter", "")
      nodes = @roger_api.partitions()
      queues = paginated_queues(nodes, page_size, page_number, filter)

      {:ok, json} = Poison.encode(queues)
      json_response(conn, json)
    end

    options "/pause", do: no_content_response(conn, 207)
    put "/pause" do
      conn = fetch_query_params(conn)
      queues = Map.get(conn.query_params, "queues", [])
      filter = Map.get(conn.query_params, "filter", "")
      queues =
        if queues == [] do
          nodes = @roger_api.partitions()
          filtered_queues(nodes, filter)
        else
          Poison.decode(queues)
        end
      Enum.each(queues, &pause_queue/1)

      no_content_response(conn, 207)
    end

    options "/resume", do: no_content_response(conn, 207)
    put "/resume" do
      conn = fetch_query_params(conn)
      queues = Map.get(conn.query_params, "queues", [])
      filter = Map.get(conn.query_params, "filter", "")
      queues =
      if queues == [] do
        nodes = @roger_api.partitions()
        filtered_queues(nodes, filter)
      else
        Poison.decode(queues)
      end
      Enum.each(queues, &pause_queue/1)

      no_content_response(conn, 207)
    end

    # NOTE atoms are not garbage collected, maybe an issue, maybe not:
    # https://engineering.klarna.com/monitoring-erlang-atoms-c1d6a741328e
    put "/pause/:partition_name/:queue_name" do
      @roger_api.queue_pause(partition_name, String.to_atom(queue_name))
      no_content_response(conn)
    end

    put "/resume/:partition_name/:queue_name" do
      @roger_api.queue_resume(partition_name, String.to_atom(queue_name))
      no_content_response(conn)
    end

    delete "/:partition_name/:queue_name" do
      @roger_api.purge_queue(partition_name, queue_name)
      no_content_response(conn)
    end

  end
end
