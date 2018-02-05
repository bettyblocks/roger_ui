defmodule RogerUi.Web.QueuesPlugTest do
  use ExUnit.Case
  use Plug.Test
  alias RogerUi.Web.QueuesPlug.Router

  defp create_queues do
    Poison.encode!(%{
      queues: [
        %{queue_name: "default",
          qualified_queue_name: "roger_demo_partition-default",
          partition_name: "roger_demo_partition"}]})
  end

  test "pause queues" do
    conn = :put
    |> conn("/pause", create_queues())
    |> Router.call([])

    assert conn.status == 207
  end

  test "resume queues" do
    conn = :put
    |> conn("/resume", create_queues())
    |> Router.call([])

    assert conn.status == 207
  end

  test "delete queues" do
    conn = :delete
    |> conn("/delete", create_queues())
    |> Router.call([])

    assert conn.status == 207
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
end
