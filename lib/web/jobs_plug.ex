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
    import RogerUi.Web.ResponseHelper
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    get "/:partition_name/:queue_name" do
      roger_now = Roger.now()
      queued_jobs = @roger_api.queued_jobs(partition_name, queue_name)

      running_jobs =
        partition_name
        |> @roger_api.running_jobs()
        |> Enum.into(%{})

      {:ok, json} =
        Poison.encode(%{
              roger_now: roger_now,
              queued_jobs: queued_jobs,
              running_jobs: running_jobs
                      })

      json_response(conn, json)
    end

    delete "/:partition_name/:job_id" do
      @roger_api.cancel_job(partition_name, job_id)
      no_content_response(conn)
    end
  end
end
