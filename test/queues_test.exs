defmodule RogerUi.Web.QueuesTest do
  use ExUnit.Case
  alias RogerUi.Tests.RogerApiInMemory, as: API
  alias RogerUi.Queues

  describe "filtered queues" do
    test "not exists" do
      queues = Queues.filter(API.partitions(), "not_exists")
      assert Enum.empty?(queues)
    end
  end
end
