defmodule VirtualOffice.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      VirtualOffice.Repo,

      VirtualOffice.Group.AssociationCache,
      VirtualOffice.Communication.ConversationCache,
      VirtualOffice.Communication.ConversationRegistry,
      # Start the Telemetry supervisor
      VirtualOfficeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: VirtualOffice.PubSub},
      # Start the Endpoint (http/https)
      VirtualOfficeWeb.Endpoint
      # Start a worker by calling: VirtualOffice.Worker.start_link(arg)
      # {VirtualOffice.Worker, arg}

    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VirtualOffice.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    VirtualOfficeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
