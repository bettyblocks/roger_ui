defmodule RogerUi.Helpers.Request do
  @moduledoc """
  This module provides Roger UI helper functions. These functions are used in order to prepare request methods of:
  - parameters reading.
  - JSON parsing.
  Request Helper functions may be required by any module used by Roger UI and these are independents of business logic.
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
