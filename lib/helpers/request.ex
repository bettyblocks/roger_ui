defmodule RogerUi.Helpers.Request do
defmodule RogerUI.Helpers.Request do
  @moduledoc """
  Functions to prepare response:
  - read parameters
  - parse JSON
  """

  alias Plug.Parsers

  @doc """
  Uses Plug.Parsers to get the body_params.
  Additionally load the query_params.
  """
  def fill_params(conn, opts \\ []) do
    opts =
      opts
      |> Keyword.put_new(:parsers, [:json])
      |> Keyword.put_new(:json_decoder, Poison)

    Parsers.call(conn, Parsers.init(opts))
  end

  @doc """
  `normalize_params/1` creates a new map structure with several keys associated with the values obtained from his input (conn).
  """

  def normalize_params(conn) do
    %{
      filter: Map.get(conn.params, "filter", ""),
      jobs: Map.get(conn.params, "jobs", []),
      page_number: conn.params |> Map.get("page_number", "0") |> String.to_integer(),
      page_size: conn.params |> Map.get("page_size", "0") |> String.to_integer(),
      partition_name: Map.get(conn.params, "partition_name", ""),
      queue_name: Map.get(conn.params, "queue_name", "")
    }
  end
end
