# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :short_story,
  ecto_repos: [ShortStory.Repo]

# Configures the endpoint
config :short_story, ShortStory.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "B3LIcO06UzptZSvfcuoV3zmLBlLmNZGABdsp1VRehvT+Il84VsogQNhd6EauPBfZ",
  render_errors: [view: ShortStory.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ShortStory.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
