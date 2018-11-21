# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :samlinks,
  ecto_repos: [Samlinks.Repo]

# Configures the endpoint
config :samlinks, SamlinksWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hp6MeNwfKhLnym88lD2u2aanSjdOMIDMBV9zLriIySQtQ/rB5zGDL/w+xQYi9VEZ",
  render_errors: [view: SamlinksWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Samlinks.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :mime, :types, %{
  "application/json" => ["json"]
}

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# hostname to use in the links
config :samlinks, :hostname, "s.am"

# periodic timer for the scheduler to clean the system
config :samlinks, :gc_time, 60_000 # 2 * 60 * 60 * 1000

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
