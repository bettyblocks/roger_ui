defmodule RogerUi.Web.JobsPlugTest do
  use ExUnit.Case
  use Plug.Test
  alias RogerUi.Web.JobsPlug.Router

  test "get jobs" do
    conn = :get
    |> conn("/roger_ui_test_partition/default")
    |> Router.call([])

    assert conn.status == 200
    json = Poison.decode!(conn.resp_body)
    ~w(queued_jobs running_jobs roger_now)
    |> Enum.each(&(assert Map.has_key?(json, &1)))
  end

  test "cancel job" do
    conn = :delete
    |> conn("/roger_ui_test_partition/y887llhnhnh")
    |> Router.call([])

    assert conn.status == 204
  end

  test "get all jobs paginated" do
    conn = :get
    |> conn("all/5/1")
    |> Router.call([])

    assert conn.status == 200
    json = Poison.decode!(conn.resp_body)
    assert Enum.count(json["jobs"]) == 5
    assert json["total"] == 10

    conn = :get
    |> conn("all/5/2")
    |> Router.call([])
    json = Poison.decode!(conn.resp_body)
    assert Enum.count(json["jobs"]) == 5
  end

  test "get all jobs paginated and filtered" do
    conn = :get
    |> conn("all/10/1?filter=create")
    |> Router.call([])

    assert conn.status == 200
    json = Poison.decode!(conn.resp_body)
    assert Enum.count(json["jobs"]) == 10
  end

end
