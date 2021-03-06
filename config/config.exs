# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :bde, BdeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BdDInlMm4D55PboPyTr4t1bXZ964ttm22KBUUHzxoovbmurc6oo07wl0gdn0+mCl",
  render_errors: [view: BdeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Bde.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Update your configuration to enable writing LiveView templates with the .leex extension.
config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

config :bde, BdeWeb.Endpoint, live_view: [signing_salt: "WyiVE/4S0scpNQxWWm9hicewdNCH4hs+"]

config :bde, Bde.Memoize, default_ttl: 5 * 60

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
