defmodule RogerUi.Web.RouterPlug do
  @moduledoc """
  Plug to expose RogerUi API
  """

  require Logger
  alias RogerUi.Web.RouterPlug.Router

  alias Roger.Info

  def init(opts), do: opts

  def call(conn, opts) do
    Router.call(conn, Router.init(opts))
  end

  defmodule Router do
    @roger_info_api Application.get_env(:roger_ui, :roger_info_api)

    @moduledoc """
    Plug Router extension
    """

    import Plug.Conn
    use Plug.Router

    plug Plug.Static,
      at: "/",
      from: :roger_ui,
      only: ~w(css js)

    plug :match
    plug :dispatch

    defp no_content_response(ncr_conn) do
      ncr_conn
      |> put_resp_header("access-control-allow-origin", "*")
      |> send_resp(204, "")
      |> halt()
    end

    defp json_response(j_conn, json) do
      j_conn
      |> put_resp_header("access-control-allow-origin", "*")
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, json)
      |> halt()
    end

    defp named_queues(partition, name) do
      queues = partition[name]
      queues
      |> Map.keys()
      |> Enum.map(fn qn ->
        %{qualified_queue_name: Roger.Queue.make_name(name, qn),
          queue_name: qn,
          partition_name: name,
          details: partition[name][qn]
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

    def paginated_queues(nodes, page_size, page_number, filter \\ "") do
      queues = nodes
      |> Enum.map(fn node -> extract_queues(node) end)
      |> List.flatten()

      queues = if filter == "" do
        queues
      else
        Enum.filter(queues, fn q -> String.contains?(q.qualified_queue_name, filter) end)
      end
      Enum.slice(queues, page_size * (page_number - 1), page_size)
    end

    # {nodes: {:node_name_1 {partition_name_1: {queue_name_1: {...}}}}}}
    get "/api/nodes" do
      nodes = Info.partitions()
      |> Enum.into(%{})
      {:ok, json} = Poison.encode(%{nodes: nodes})
      json_response(conn, json)
    end

    get "/api/jobs/:partition_name/:queue_name" do
      roger_now = Roger.now()
      queued_jobs = Info.queued_jobs(partition_name, queue_name)
      running_jobs = partition_name
      |> Info.running_jobs()
      |> Enum.into(%{})

      {:ok, json} = Poison.encode(%{roger_now: roger_now,
                                    queued_jobs: queued_jobs,
                                    running_jobs: running_jobs})
      json_response(conn, json)
    end

    get "/api/queues/:page_size/:page_number" do
      queues = @roger_info_api.partitions()
      |> paginated_queues(page_size |> String.to_integer, page_number |> String.to_integer)

      {:ok, json} = Poison.encode(%{queues: queues})
      json_response(conn, json)
    end

    get "/api/queues/:page_size/:page_number/:filter" do
      queues = @roger_info_api.partitions()
      |> paginated_queues(page_size |> String.to_integer, page_number |> String.to_integer, filter)

      {:ok, json} = Poison.encode(%{queues: queues})
      json_response(conn, json)
    end

    # NOTE atoms are not garbage collected, maybe an issue, maybe not:
    # https://engineering.klarna.com/monitoring-erlang-atoms-c1d6a741328e
    put "api/queues/pause/:partition_name/:queue_name" do
      Roger.Partition.Global.queue_pause(partition_name, String.to_atom(queue_name))
      no_content_response(conn)
    end

    put "api/queues/resume/:partition_name/:queue_name" do
      Roger.Partition.Global.queue_resume(partition_name, String.to_atom(queue_name))
      no_content_response(conn)
    end

    delete "api/queues/:partition_name/:queue_name" do
      Roger.Queue.purge(partition_name, queue_name)
      no_content_response(conn)
    end

    delete "api/jobs/:partition_name/:job_id" do
      Roger.Partition.Global.cancel_job(partition_name, job_id)
      no_content_response(conn)
    end

    match _ do
      index_path = Path.join([Application.app_dir(:roger_ui), "priv/static/index.html"])
      conn
      |> put_resp_header("content-type", "text/html")
      |> send_file(200, index_path)
      |> halt()
    end
  end
end
