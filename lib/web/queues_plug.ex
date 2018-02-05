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
    alias RogerUi.Web.ResponseHelper, as: RH
    alias RogerUi.QueuesHelper, as: QH
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    defp selected_queues(queues, filter) do
      if queues == [] do
        @roger_api.partitions() |> QH.filtered_queues(filter)
      else
        Poison.decode(queues)
      end
    end

    defp action_over_queues(conn, action) do
      conn = fetch_query_params(conn)
      queues = Map.get(conn.query_params, "queues", [])
      filter = Map.get(conn.query_params, "filter", "")
      queues
      |> selected_queues(filter)
      |> Enum.each(fn q -> action.(q.partition_name, QH.atom_name(q.queue_name)) end)

      RH.no_content_response(conn, 207)
    end

    get "/:page_size/:page_number" do
      conn = fetch_query_params(conn)
      page_size = String.to_integer(page_size)
      page_number = String.to_integer(page_number)
      filter = Map.get(conn.query_params, "filter", "")
      queues =
        @roger_api.partitions()
        |> QH.paginated_queues(page_size, page_number, filter)

      {:ok, json} = Poison.encode(queues)
      RH.json_response(conn, json)
    end

    options "/pause", do: RH.no_content_response(conn, 207)
    put "/pause", do: action_over_queues(conn, &@roger_api.queue_pause/2)

    options "/resume", do: RH.no_content_response(conn, 207)
    put "/resume", do: action_over_queues(conn, &@roger_api.queue_resume/2)

    options "/delete", do: RH.no_content_response(conn, 207)
    delete "/delete", do: action_over_queues(conn, &@roger_api.purge_queue/2)
  end
end
