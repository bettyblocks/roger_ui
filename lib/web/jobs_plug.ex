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

    get "all/:page_size/:page_number" do
      conn = Request.fill_params(conn)
      page_size = String.to_integer(page_size)
      page_number = String.to_integer(page_number)
      filter = Map.get(conn.params, "filter", "")

      jobs =
        @roger_api.running_jobs()
        |> Jobs.normalize()
        |> Filter.call(:module, filter)
        |> Page.extract("jobs", page_size, page_number)

      Response.json(conn, jobs)
    end

    get "/:partition_name/:queue_name" do
      roger_now = Roger.now()
      queued_jobs = @roger_api.queued_jobs(partition_name, queue_name)
      running_jobs =
        partition_name
        |> @roger_api.running_jobs()
        |> Enum.into(%{})
      body = %{
          roger_now: roger_now,
          queued_jobs: queued_jobs,
          running_jobs: running_jobs
        }

      Response.json(conn, body)
    end

    delete "/:partition_name/:job_id" do
      @roger_api.cancel_job(partition_name, job_id)
      Response.no_content(conn)
    end
  end
end
