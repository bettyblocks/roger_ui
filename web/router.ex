defmodule RogerUi.RouterPlug do
  @moduledoc """
  Plug to expose RogerUi API
  """

  require Logger
  alias RogerUi.RouterPlug.Router

  alias Roger.Info

  def init(opts), do: opts

  def call(conn, opts) do
    Router.call(conn, Router.init(opts))
  end

  defmodule Router do
    @moduledoc """
    Plug Router extension
    """

    import Plug.Conn
    use Plug.Router

    plug Plug.Static,
      at: "/",
      from: :roger_ui,
      only: ~w(assets templates)

    plug :match
    plug :dispatch

    # {nodes: {:node_name_1 {partition_name_1: {queue_name_1: {...}}}}}}
    get "/api/nodes" do
      nodes = Info.running_partitions()
      |> Enum.into(%{})
      {:ok, json} = Poison.encode(%{nodes: nodes})

      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, json)
      |> halt()
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

      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, json)
      |> halt()
    end

    put "api/queues/pause/:partition_name/:queue_name" do
      Roger.Partition.Global.queue_pause(partition_name, queue_name)

      conn
      |> send_resp(204, "")
      |> halt()
    end

    put "api/queues/resume/:partition_name/:queue_name" do
      Roger.Partition.Global.queue_resume(partition_name, queue_name)

      conn
      |> send_resp(204, "")
      |> halt()
    end

    delete "api/queues/:partition_name/:queue_name" do
      Roger.Queue.purge(partition_name, queue_name)

      conn
      |> send_resp(204, "")
      |> halt()
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
