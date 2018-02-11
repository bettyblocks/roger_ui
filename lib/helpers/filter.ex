defmodule RogerUi.Helpers.Filter do
  @moduledoc """
  Take a enumeration and returns only filtered element
  """

  @spec call(
          xs :: Enumerable.t(),
          field :: String.t(),
          filter :: String.t()
        ) :: []
  def call(xs, _, ""), do: xs

  def call(xs, field, filter) do
    filter = String.upcase(filter)

    Stream.filter(xs, fn e ->
      e
      |> Map.get(field)
      |> to_string()
      |> String.upcase()
      |> String.contains?(filter)
    end)
  end
end
