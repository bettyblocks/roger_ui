defmodule RogerUi.Web.QueuesHelperTest do
  use ExUnit.Case
  alias RogerUi.Tests.RogerApiInMemory, as: API
  alias RogerUi.QueuesHelper

  test "queues paginated from nodes" do
    queues =
      API.partitions()
      |> QueuesHelper.filtered_queues("not_exists")
    assert Enum.empty?(queues)
  end
end
