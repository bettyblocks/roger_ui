defmodule RogerUI.Helpers.Filter do
  @moduledoc """
  Take a enumeration and returns only filtered element
  """

  @spec call(
          xs :: Enumerable.t(),
          field :: String.t(),
          filter :: String.t()
        ) :: []

  @doc """
  `call/1`  takes an enumerable , a string called field  and another string called filter,
  the function takes the field and filter the enumerable by the filter applied.
  """
  def call(enumerable, _, ""), do: enumerable

  def call(enumerable, field, filter) do
    filter = String.upcase(filter)

    Stream.filter(enumerable, fn e ->
      e
      |> Map.get(field)
      |> to_string()
      |> String.upcase()
      |> String.contains?(filter)
    end)
  end
end
