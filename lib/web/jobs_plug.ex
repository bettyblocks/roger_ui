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
    alias RogerUi.Helpers.Response
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    defp filtered_jobs(jobs, filter) do
      if filter == "" do
        jobs
      else
        Enum.filter(jobs, fn j ->
          j.module
          |> to_string()
          |> String.upcase()
          |> String.contains?(filter)
        end)
      end
    end

    defp paginated_jobs(jobs, page_size, page_number, filter) do
      page_size = if page_size > 100, do: 100, else: page_size
      jobs = filtered_jobs(jobs, filter)
      page_start_index = page_size * (page_number - 1)

      %{
        jobs: Enum.slice(jobs, page_start_index, page_size),
        total: Enum.count(jobs)
      }
    end

    get "all/:page_size/:page_number" do
      conn = fetch_query_params(conn)
      page_size = String.to_integer(page_size)
      page_number = String.to_integer(page_number)
      filter = conn.query_params |> Map.get("filter", "") |> String.upcase()

      jobs =
        @roger_api.running_jobs()
        |> Keyword.values()
        |> List.flatten()
        |> Enum.reduce([], fn n, accum -> [Map.values(n) | accum] end)
        |> List.flatten()
        |> paginated_jobs(page_size, page_number, filter)

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
