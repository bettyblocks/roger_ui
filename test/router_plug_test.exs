defmodule RogerUi.Web.RouterPlugTest do
  use ExUnit.Case
  use Plug.Test
  alias RogerUi.Web.RouterPlug.Router

  test "index page" do
    conn = :get
    |> conn("/")
    |> Router.call([])

    assert conn.status == 200
  end

  test "get nodes" do
    conn = :get
    |> conn("/api/nodes")
    |> Router.call([])

    assert conn.status == 200
    json = Poison.decode!(conn.resp_body)
    assert Map.has_key?(json, "nodes")
  end
end
