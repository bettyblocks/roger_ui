defmodule RogerUI.Web.RouterPlugTest do
  use ExUnit.Case
  use Plug.Test
  alias RogerUI.Web.RouterPlug.Router
  alias RogerUI.Tests.RogerApiInMemory
  import Mox

  test "index page" do
    conn =
      :get
      |> conn("/")
      |> Router.call([])

    assert conn.status == 200
  end

  test "get nodes" do
    RogerUI.RogerApi.Mock
    |> expect(:partitions, &RogerApiInMemory.partitions/0)

    conn =
      :get
      |> conn("/api/nodes")
      |> Router.call([])

    assert conn.status == 200
    json = Poison.decode!(conn.resp_body)
    assert Map.has_key?(json, "nodes")
  end
end
