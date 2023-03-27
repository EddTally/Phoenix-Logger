defmodule LoggerTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LoggerTestWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LoggerTest.PubSub},
      # Start the Endpoint (http/https)
      LoggerTestWeb.Endpoint
      # Start a worker by calling: LoggerTest.Worker.start_link(arg)
      # {LoggerTest.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LoggerTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LoggerTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
