defmodule RogerUi.Helpers.Filter do
  @moduledoc """
  Take a enumeration and returns only filtered element
  """

  @spec call(xs :: Stream.t(), field :: String.t(), filter :: String.t()) :: []
  def call(xs, _, ""), do: xs
  def call(xs, field, filter) do
    filter = String.upcase(filter)
    Stream.filter(xs, fn e ->
      e[field] |> String.upcase() |> String.contains?(filter)
    end)
  end
end
