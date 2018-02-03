defmodule RogerUi.Web.ResponseHelper do
  @moduledoc """
  CORS and JSON
  """
  import Plug.Conn

  def no_content_response(ncr_conn) do
    ncr_conn
    |> put_resp_header("access-control-allow-origin", "*")
    |> send_resp(204, "")
    |> halt()
  end

  def json_response(j_conn, json) do
    j_conn
    |> put_resp_header("access-control-allow-origin", "*")
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, json)
    |> halt()
  end
end
