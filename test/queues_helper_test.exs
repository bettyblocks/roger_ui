defmodule RogerUi.Web.QueuesHelperTest do
  use ExUnit.Case
  alias RogerUi.Tests.RogerApiInMemory, as: API
  alias RogerUi.QueuesHelper

  test "queues paginated from nodes" do
    queues =
      API.partitions()
      |> QueuesHelper.paginated_queues(10, 1)
    assert Enum.count(queues) == 10
  end
end
