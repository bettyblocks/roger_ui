defmodule RogerUi.Web.RouterTest do
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

  # test "get jobs" do
  #   conn = :get
  #   |> conn("/api/jobs/roger_ui_test_partition/default")
  #   |> Router.call([])

  #   assert conn.status == 200
  #   json = Poison.decode!(conn.resp_body)
  #   ~w(queued_jobs running_jobs roger_now)
  #   |> Enum.each(&(assert Map.has_key?(json, &1)))
  # end

  test "pause queue" do
    conn = :put
    |> conn("/api/queues/pause/roger_ui_test_partition/default")
    |> Router.call([])

    assert conn.status == 204
  end

  test "resume queue" do
    conn = :put
    |> conn("/api/queues/resume/roger_ui_test_partition/default")
    |> Router.call([])

    assert conn.status == 204
  end

  # test "purge queue" do
  #   conn = :delete
  #   |> conn("api/queues/roger_ui_test_partition/default")
  #   |> Router.call([])

  #   assert conn.status == 204
  # end

  test "cancel job" do
    conn = :delete
    |> conn("api/jobs/roger_ui_test_partition/y887llhnhnh")
    |> Router.call([])

    assert conn.status == 204
  end

  test "get all queues paginated" do
    conn = :get
    |> conn("/api/queues/10/1")
    |> Router.call([])

    assert conn.status == 200
    json = Poison.decode!(conn.resp_body)
    assert Enum.count(json["queues"]) == 10
    assert json["total"] == 12

    conn = :get
    |> conn("/api/queues/10/2")
    |> Router.call([])
    json = Poison.decode!(conn.resp_body)
    assert Enum.count(json["queues"]) == 2
  end

  test "get all queues paginated and filtered" do
    conn = :get
    |> conn("/api/queues/10/1?filter=fast")
    |> Router.call([])

    assert conn.status == 200
    json = Poison.decode!(conn.resp_body)
    assert Enum.count(json["queues"]) == 4
  end
end
