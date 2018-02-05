defmodule RogerUi.Web.ResponseHelper do
  @moduledoc """
  CORS and JSON
  """
  import Plug.Conn

  defp set_cors_headers(conn) do
    conn
    |> put_resp_header("access-control-allow-methods", "GET, POST, PATCH, PUT, DELETE, OPTIONS")
    |> put_resp_header("access-control-allow-headers", "origin, content-type, x-auth-token")
    |> put_resp_header("access-control-allow-origin", "*")
  end

  def no_content_response(ncr_conn, status_number \\ 204) do
    ncr_conn
    |> set_cors_headers()
    |> send_resp(status_number, "")
    |> halt()
  end

  def json_response(j_conn, json) do
    j_conn
    |> set_cors_headers()
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, json)
    |> halt()
  end
end
