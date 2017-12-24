# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :staff_notes,
  author_name: "Lee Dohm",
  author_url: "http://www.lee-dohm.com",
  ecto_repos: [StaffNotes.Repo],
  generators: [binary_id: true],
  github_url: "https://github.com/lee-dohm/staff-notes"

# Configures the endpoint
config :staff_notes, StaffNotesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zb9dt/VPhENEdWX7Vi9gjy/1i66u0bqu+HwgcbyqBijV2CQsQDVNgw/sIrRIPsIO",
  render_errors: [view: StaffNotesWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: StaffNotes.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

config :slime, :embedded_engines, %{
  markdown: StaffNotesWeb.MarkdownEngine
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
