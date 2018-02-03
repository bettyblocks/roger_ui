defmodule RogerUi.Web.QueuesPlugTest do
  use ExUnit.Case
  use Plug.Test
  alias RogerUi.Web.QueuesPlug.Router

  test "pause queue" do
    conn = :put
    |> conn("/pause/roger_ui_test_partition/default")
    |> Router.call([])

    assert conn.status == 204
  end

  test "resume queue" do
    conn = :put
    |> conn("/resume/roger_ui_test_partition/default")
    |> Router.call([])

    assert conn.status == 204
  end

  test "get all queues paginated" do
    conn = :get
    |> conn("/10/1")
    |> Router.call([])

    assert conn.status == 200
    json = Poison.decode!(conn.resp_body)
    assert Enum.count(json["queues"]) == 10
    assert json["total"] == 12

    conn = :get
    |> conn("/10/2")
    |> Router.call([])
    json = Poison.decode!(conn.resp_body)
    assert Enum.count(json["queues"]) == 2
  end

  test "get all queues paginated and filtered" do
    conn = :get
    |> conn("/10/1?filter=fast")
    |> Router.call([])

    assert conn.status == 200
    json = Poison.decode!(conn.resp_body)
    assert Enum.count(json["queues"]) == 4
  end

  test "purge queue" do
    conn = :delete
    |> conn("/roger_ui_test_partition/default")
    |> Router.call([])

    assert conn.status == 204
  end
end
