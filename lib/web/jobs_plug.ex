defmodule RogerUi.Web.JobsPlug do
  @moduledoc """
  Endpoints to process jobs api calls
  """

  require Logger
  alias RogerUi.Web.JobsPlug.Router

  def init(opts), do: opts

  def call(conn, opts) do
    Router.call(conn, Router.init(opts))
  end

  defmodule Router do
    @moduledoc """
    Plug Router extension for JobsPlug
    """

    @roger_api Application.get_env(:roger_ui, :roger_api, RogerUi.RogerApi)

    import Plug.Conn
    alias RogerUi.Helpers.{Page, Response, Request, Filter}
    alias RogerUi.Jobs
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    get "/:page_size/:page_number" do
      conn = Request.fill_params(conn)
      params = normalize_params(conn)

      jobs =
        if params.partition_name != "" && params.queue_name != "" do
          @roger_api.queued_jobs(params.partition_name, params.queue_name)
        else
          @roger_api.running_jobs()
        end

      jobs = filtered_and_paginated_jobs(jobs, params)

      Response.json(conn, jobs)
    end

    options("/", do: Response.no_content(conn, 207))

    delete "/" do
      conn = Request.fill_params(conn)
      params = normalize_params(conn)

      params.jobs
      |> selected_jobs(params.filter)
      |> Enum.each(fn j ->
        @roger_api.cancel_job(j["partition_name"], j["job_id"])
      end)

      Response.no_content(conn)
    end

    defp filtered_and_paginated_jobs(jobs, params) do
      jobs
      |> Filter.call(:module, params.filter)
      |> Page.extract("jobs", params.page_size, params.page_number)
    end

    defp selected_jobs([], filter), do: filtered_jobs(filter)
    defp selected_jobs(jobs, _), do: jobs

    defp normalize_params(conn) do
      %{
        filter: Map.get(conn.params, "filter", ""),
        jobs: Map.get(conn.params, "jobs", []),
        page_number: String.to_integer(conn.params, "page_number", 0),
        page_size: String.to_integer(conn.params, "page_size", 0),
        partition_name: Map.get(conn.params, "partition_name", ""),
        queue_name: Map.get(conn.params, "queue_name", "")
      }
    end
  end
end
