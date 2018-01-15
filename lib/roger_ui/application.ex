defmodule RogerUi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    run_server? = Application.get_env(:roger_ui, :server, true)
    web_port = Application.get_env(:roger_ui, :web_port, 4040)
    if run_server? do
      case Plug.Adapters.Cowboy.http(RogerUi.RouterPlug, [], port: web_port) do
        {:ok, _} ->
          IO.puts("Starting RogerUi server on port #{web_port}")
        {:error, :eaddrinuse} ->
          IO.puts("RogerUi Server already have been started on port #{web_port}")
      end
    end
    Supervisor.start_link([], strategy: :one_for_one)
  end
end
