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

    plug :match
    plug :dispatch

    get "/api/partitions" do
      partitions = Info.running_partitions()
      |> Enum.into(%{})
      {:ok, json} = Poison.encode(%{partitions: partitions})

      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, json)
      |> halt()
    end

    get "/api/queues" do
      partitions = Info.running_partitions()
      |> Enum.into(%{})
      {:ok, json} = Poison.encode(%{partitions: partitions})

      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, json)
      |> halt()
    end

    get "/templates/:template" do
      template_path = Path.join([Application.app_dir(:roger_ui), "priv/static/templates/#{template}"])
      conn
      |> put_resp_header("content-type", "text/html")
      |> send_file(200, template_path)
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
