defmodule RogerUi.Jobs do
  @moduledoc """
  Generate Jobs list from Roger.Info.running_jobs()
  """

  def normalize(jobs) do
    jobs
    |> Keyword.values()
    |> Enum.flat_map(&Map.values/1)
    |> List.flatten()
  end
end
