# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :writers_unblocked,
  ecto_repos: [WritersUnblocked.Repo]

# Configures the endpoint
config :writers_unblocked, WritersUnblockedWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "AZV7dzRAr8essrQqgl9dJdkeWwnK9hzmMAYatZ+3BQWbUwHec163t72ZCQOaiffY",
  render_errors: [view: WritersUnblockedWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WritersUnblocked.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :writers_unblocked, Story_Config,
  entry_length: 600,
  # Amount of characters required before a story can be finished.
  finish_length: 2500

config :writers_unblocked, Viewer,
  # Number of random stories to display every time the viewer is entered
  number_of_stories: 10


config :writers_unblocked, Vote,
  votes_per_user: 3

config :writers_unblocked, Wait_Time,
  # Number of seconds to wait until post is unlocked, will default to an hour, AKA 3600 secs
  seconds_to_wait: 15

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
