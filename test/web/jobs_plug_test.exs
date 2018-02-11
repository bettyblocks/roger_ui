defmodule RogerUi.Web.JobsPlugTest do
  use ExUnit.Case
  use Plug.Test
  alias RogerUi.Web.JobsPlug.Router
  alias RogerUi.Tests.RogerApiInMemory
  import Mox

  setup :verify_on_exit!

  test "get jobs" do
    RogerUi.RogerApi.Mock
    |> expect(:queued_jobs, fn _, _ -> %{} end)
    |> expect(:running_jobs, &RogerApiInMemory.running_jobs/1)

    conn =
      :get
      |> conn("/roger_ui_test_partition/default")
      |> Router.call([])

    assert conn.status == 200
    json = Poison.decode!(conn.resp_body)

    ~w(queued_jobs running_jobs roger_now)
    |> Enum.each(&assert Map.has_key?(json, &1))
  end

  test "cancel job" do
    RogerUi.RogerApi.Mock
    |> expect(:cancel_job, fn _, _ -> :ok end)

    conn =
      :delete
      |> conn("/roger_ui_test_partition/y887llhnhnh")
      |> Router.call([])

    assert conn.status == 204
  end

  test "get all jobs paginated" do
    RogerUi.RogerApi.Mock
    |> expect(:running_jobs, 2, &RogerApiInMemory.running_jobs/0)

    conn =
      :get
      |> conn("all/5/1")
      |> Router.call([])

    assert conn.status == 200
    json = Poison.decode!(conn.resp_body)
    assert Enum.count(json["jobs"]) == 5
    assert json["total"] == 10

    conn =
      :get
      |> conn("all/5/2")
      |> Router.call([])

    json = Poison.decode!(conn.resp_body)
    assert Enum.count(json["jobs"]) == 5
  end

  test "get all jobs paginated and filtered" do
    RogerUi.RogerApi.Mock
    |> expect(:running_jobs, &RogerApiInMemory.running_jobs/0)

    conn =
      :get
      |> conn("all/10/1?filter=create")
      |> Router.call([])

    assert conn.status == 200
    json = Poison.decode!(conn.resp_body)
    assert Enum.count(json["jobs"]) == 10
  end
end
