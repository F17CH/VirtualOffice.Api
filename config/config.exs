# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :virtual_office,
  ecto_repos: [VirtualOffice.Repo],
  generators: [binary_id: true]

  config :virtual_office, VirtualOffice.Repo, migration_timestamps: [type: :utc_datetime_usec]

# Configures the endpoint
config :virtual_office, VirtualOfficeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GPqtmudFHUN+qYuk2Lnb/ZrA9gQaS7LmSO3oQMJxakgScHDgHCXW4FI01Kyf6Tlt",
  render_errors: [view: VirtualOfficeWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: VirtualOffice.PubSub,
  live_view: [signing_salt: "CRfYPYkP"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
