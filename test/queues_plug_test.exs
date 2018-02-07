defmodule RogerUi.Web.QueuesPlugTest do
  use ExUnit.Case
  use Plug.Test
  alias RogerUi.Web.QueuesPlug.Router

  defp create_queues do
    %{
      "queues" => [
        %{"queue_name" => "default",
          "qualified_queue_name" => "roger_demo_partition-default",
          "partition_name" => "roger_demo_partition"}]}
    |> Poison.encode!()
  end

  defp json_conn(uri, body) do
    :put
    |> conn(uri, body)
    |> put_req_header("content-type", "application/json")
  end

  test "pause queues" do
    conn = json_conn("/pause?filter='hello'", create_queues())
    Router.call(conn, [])

    assert conn.status == 207
  end

  test "pause all queues" do
    conn = json_conn("/pause", %{})
    Router.call(conn, [])

    assert conn.status == 207
  end

  test "resume queues" do
    conn = json_conn("/resume", create_queues())
    Router.call(conn, [])

    assert conn.status == 207
  end

  test "purge queues" do
    conn = :put
    |> conn("/purge", create_queues())
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
