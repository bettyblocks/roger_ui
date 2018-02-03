defmodule RogerUi.RogerApi do
  @moduledoc """
  Api to calls Roger lib
  """

  @behaviour RogerUi.Roger

  def partitions(), do: Roger.Info.partitions()
end
