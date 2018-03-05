defmodule RogerUI.Web.JobsPlugTest do
  @moduledoc """
  This module provides Roger UI test functions. It tests the behaviour
  of RogerUi.Web.JobsPlug, RogerUi.RogerApi functions. This module includes
  RogerUi.Tests.RogerApiInMemory functions, necessary to simulate Roger API responses.
  """
  use ExUnit.Case, async: true
  use Plug.Test
  alias RogerUI.Web.JobsPlug.Router
  alias RogerUI.Tests.RogerApiInMemory
  import Mox

  setup :verify_on_exit!

  test "get jobs" do
    RogerUI.RogerApi.Mock
    |> expect(:queued_jobs, &RogerApiInMemory.running_jobs/0)

    conn =
      :get
      |> conn("/10/1/?partition_name=roger_ui_test_partition&queue_name=default")
      |> Router.call([])

    assert conn.status == 200
    json = Poison.decode!(conn.resp_body)

    assert Enum.count(json["jobs"]) == 10
    assert json["total"] == 2000
  end

  describe "cancel jobs" do
    test "all" do
      RogerUI.RogerApi.Mock
      |> expect(:running_jobs, &RogerApiInMemory.running_jobs/0)
      |> expect(:cancel_job, 1200, fn _, _ -> :ok end)

      conn =
        :delete
        |> conn("/")
        |> Router.call([])

      assert conn.status == 204
    end

    test "filtered" do
      RogerUI.RogerApi.Mock
      |> expect(:running_jobs, &RogerApiInMemory.running_jobs/0)
      |> expect(:cancel_job, 1200, fn _, _ -> :ok end)

      conn =
        :delete
        |> conn("/?filter=CreateUpdate")
        |> Router.call([])

      assert conn.status == 204
    end

    test "options for cors" do
      conn =
        :options
        |> conn("/")
        |> Router.call([])

      assert conn.status == 207
    end
  end

  test "get all jobs paginated" do
    RogerUI.RogerApi.Mock
    |> expect(:running_jobs, 2, &RogerApiInMemory.running_jobs/0)

    conn =
      :get
      |> conn("/5/1")
      |> Router.call([])

    assert conn.status == 200
    json = Poison.decode!(conn.resp_body)
    assert Enum.count(json["jobs"]) == 5
    assert json["total"] == 1200

    conn =
      :get
      |> conn("/5/2")
      |> Router.call([])

    json = Poison.decode!(conn.resp_body)
    assert Enum.count(json["jobs"]) == 5
  end

  test "get all jobs paginated and filtered" do
    RogerUI.RogerApi.Mock
    |> expect(:running_jobs, &RogerApiInMemory.running_jobs/0)

    conn =
      :get
      |> conn("/10/1?filter=create")
      |> Router.call([])

    assert conn.status == 200
    json = Poison.decode!(conn.resp_body)
    assert Enum.count(json["jobs"]) == 10
  end
end
