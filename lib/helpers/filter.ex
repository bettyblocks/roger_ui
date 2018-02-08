defmodule RogerUi.Helpers.Filter do
  @moduledoc """
  Take a enumeration and returns only filtered element
  """

  def call(elems, _, ""), do: elems
  def call(elems, field, filter) do
    filter = String.upcase(filter)
    Enum.filter(elems, fn e ->
      e[field] |> String.upcase() |> String.contains?(filter)
    end)
  end
end
