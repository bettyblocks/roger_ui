defmodule RogerUI.Web.Helpers.Filter do
  @moduledoc """
  Takes an enumeration and returns only those elements defined by a field and a filter. 
  """
  @spec call(
          xs :: Enumerable.t(),
          field :: String.t(),
          filter :: String.t()
        ) :: []

  @doc """
  Takes an enumerable, a field and a filter and returns it filtered
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
