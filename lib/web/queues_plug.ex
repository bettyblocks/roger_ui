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
        nodes = @roger_api.partitions()
        QH.filtered_queues(nodes, filter)
      else
        Poison.decode(queues)
      end
    end

    defp toggle_queues(conn, f) do
      conn = fetch_query_params(conn)
      queues = Map.get(conn.query_params, "queues", [])
      filter = Map.get(conn.query_params, "filter", "")
      queues
      |> selected_queues(filter)
      |> Enum.each(fn q -> f.(q.partition_name, QH.atom_name(q.queue_name)) end)

      RH.no_content_response(conn, 207)
    end

    get "/:page_size/:page_number" do
      conn = fetch_query_params(conn)
      page_size = String.to_integer(page_size)
      page_number = String.to_integer(page_number)
      filter = Map.get(conn.query_params, "filter", "")
      nodes = @roger_api.partitions()
      queues = QH.paginated_queues(nodes, page_size, page_number, filter)

      {:ok, json} = Poison.encode(queues)
      RH.json_response(conn, json)
    end

    options "/pause", do: RH.no_content_response(conn, 207)
    put "/pause", do: toggle_queues(conn, &@roger_api.queue_pause/2)

    options "/resume", do: RH.no_content_response(conn, 207)
    put "/resume", do: toggle_queues(conn, &@roger_api.queue_resume/2)

    # NOTE atoms are not garbage collected, maybe an issue, maybe not:
    # https://engineering.klarna.com/monitoring-erlang-atoms-c1d6a741328e
    put "/pause/:partition_name/:queue_name" do
      @roger_api.queue_pause(partition_name, QH.atom_name(queue_name))
      RH.no_content_response(conn)
    end

    put "/resume/:partition_name/:queue_name" do
      @roger_api.queue_resume(partition_name, QH.atom_name(queue_name))
      RH.no_content_response(conn)
    end

    delete "/:partition_name/:queue_name" do
      @roger_api.purge_queue(partition_name, queue_name)
      RH.no_content_response(conn)
    end
  end
end
