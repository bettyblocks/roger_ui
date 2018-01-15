defmodule RogerUi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    case Plug.Adapters.Cowboy.http(RogerUi.RouterPlug, [], port: 4040) do
      {:ok, _} ->
        IO.puts("Starting RogerUi server on port 4040")
      {:error, :eaddrinuse} ->
        IO.puts("RogerUi Server already have been started on port 4040")
    end
    Supervisor.start_link([], strategy: :one_for_one)
  end
end
