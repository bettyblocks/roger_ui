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

    get "/api/partitions/all" do
      partitions = Info.partitions() |> Enum.into(%{})
      {:ok, json} = Poison.encode(%{partitions: partitions})

      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, json)
      |> halt()
    end
  end
end
