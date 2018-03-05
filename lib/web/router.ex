defmodule RogerUI.Web.RouterPlug do
  @moduledoc """
  Plug to expose RogerUI API
  """

  require Logger
  require EEx
  alias RogerUI.Web.RouterPlug.Router
  alias Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    ns = opts[:namespace] || ""
    conn = Conn.assign(conn, :namespace, ns)

    case ns do
      "" ->
        Router.call(conn, Router.init(opts))

      _ ->
        namespace(conn, opts, ns)
    end
  end

  defp namespace(%Conn{path_info: [ns | path]} = conn, opts, ns) do
    Router.call(%Conn{conn | path_info: path}, Router.init(opts))
  end

  defp namespace(conn, _opts, _ns), do: conn

  defmodule Router do
    @moduledoc """
    Plug Router extension
    """

    import Plug.Conn

    alias RogerUI.Web.Helpers.Response
    use Plug.Router

    @roger_api Application.get_env(:roger_ui, :roger_api, RogerUI.RogerApi)

    plug(
      Plug.Static,
      at: "/",
      from: :roger_ui,
      only: ~w(css js)
    )

    plug(:match)
    plug(:dispatch)

    forward("/api/jobs", to: RogerUI.Web.JobsPlug)
    forward("/api/partitions", to: RogerUI.Web.PartitionsPlug)
    forward("/api/queues", to: RogerUI.Web.QueuesPlug)

    # {nodes: {:node_name_1 {partition_name_1: {queue_name_1: {...}}}}}}
    get "/api/nodes" do
      nodes =
        @roger_api.partitions()
        |> Enum.into(%{})

      Response.json(conn, %{nodes: nodes})
    end

    index_path = Path.join([Application.app_dir(:roger_ui), "priv/static/index.html"])
    EEx.function_from_file(:defp, :render_index, index_path, [:assigns])

    match _ do
      base =
        case conn.assigns[:namespace] do
          "" -> ""
          namespace -> "#{namespace}"
        end

      conn
      |> put_resp_header("content-type", "text/html")
      |> send_resp(200, render_index(base: base))
      |> halt()
    end
  end
end
