defmodule PopContest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PopContestWeb.Telemetry,
      # Start the Ecto repository
      PopContest.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: PopContest.PubSub},
      # Start Finch
      {Finch, name: PopContest.Finch},
      # Start the Endpoint (http/https)
      PopContestWeb.Endpoint
      # Start a worker by calling: PopContest.Worker.start_link(arg)
      # {PopContest.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PopContest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PopContestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
