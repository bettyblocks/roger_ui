defmodule RogerUi.Web.PartitionsPlug do
  @moduledoc """
  Endpoints to process partitions api calls
  """

  require Logger
  alias RogerUi.Web.PartitionsPlug.Router

  def init(opts), do: opts

  def call(conn, opts) do
    Router.call(conn, Router.init(opts))
  end

  defmodule Router do
    @moduledoc """
    Plug Router extension for PartitionsPlug
    """

    @roger_api Application.get_env(:roger_ui, :roger_api, RogerUi.RogerApi)

    import Plug.Conn
    alias RogerUi.Helpers.{Page, Response, Request, Filter}
    alias RogerUi.Partitions
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    get "/:page_size/:page_number" do
      conn = Request.fill_params(conn)
      params = Request.normalize_params(conn)

      partitions =
        @roger_api.partitions()
        |> Partitions.normalize()
        |> Enum.sort_by(&Map.get(&1, "partition_name"))
        |> Filter.call("partition_name", params.filter)
        |> Page.extract("partitions", params.page_size, params.page_number)

      Response.json(conn, partitions)
    end

    options("/", do: Response.no_content(conn, 207))

    delete "/" do
      conn = Request.fill_params(conn)
      params = Request.normalize_params(conn)

      params.partitions
      |> selected_partitions(params)
      |> Enum.each(fn j ->
        @roger_api.cancel_partition(j["partition_name"], j["job_id"])
      end)

      Response.no_content(conn)
    end

    defp selected_partitions([], params) do
      @roger_api.partitions()
      |> Enum.sort_by(&Map.get(&1, :id))
      |> Filter.call(:module, params.filter)
    end

    defp selected_partitions(partitions, _), do: partitions
  end
end
