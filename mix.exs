defmodule StaffNotes.Mixfile do
  use Mix.Project

  @version "0.0.1"

  def project do
    [
      app: :staff_notes,
      name: "Staff Notes",
      version: @version,
      description: "A web application for storing and sharing staff notes about community members",

      homepage_url: "https://www.staffnotes.io",
      source_url: "https://github.com/lee-dohm/staff-notes",

      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),

      preferred_cli_env: [coveralls: :test],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],

      aliases: aliases(),
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    [
      mod: {StaffNotes.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp aliases do
    [
      "ecto.ci": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"]
    ]
  end

  defp deps do
    [
      {:cmark, "~> 0.7"},
      {:cowboy, "~> 1.0"},
      {:ecto_enum, "~> 1.1"},
      {:ex_aws, "~> 2.0"},
      {:ex_aws_s3, "~> 2.0"},
      {:gettext, "~> 0.11"},
      {:oauth2, "~> 0.9"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix, "~> 1.3.0"},
      {:phoenix_octicons, "~> 0.2.0"},
      {:phoenix_slime, "~> 0.9"},
      {:plug_ribbon, "~> 0.2.1"},
      {:postgrex, ">= 0.0.0"},
      {:timex, "~> 3.1"},
      {:dotenv, "~> 3.0", only: :dev},
      {:ex_doc, "~> 0.18", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.8", only: :test},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:floki, "~> 0.19", only: [:dev, :test]}
    ]
  end

  defp docs do
    [
      main: docs_main(Mix.env()),
      source_url: "https://github.com/lee-dohm/staff-notes",
      markdown_processor: ExDoc.Markdown.Cmark,
      groups_for_modules: [
        Accounts: [
          ~r{^StaffNotes\.Accounts}
        ],
        Controllers: [
          ~r{^StaffNotes.*Controller$}
        ],
        "Ecto Types": [
          ~r{^StaffNotes.Ecto.*}
        ],
        Helpers: [
          ~r{^StaffNotes.*Helpers$}
        ],
        Localization: [
          StaffNotesWeb.Gettext
        ],
        Markdown: [
          ~r{Markdown}
        ],
        Notes: [
          ~r{^StaffNotes.Notes}
        ],
        OAuth: [
          StaffNotesWeb.GitHub
        ],
        Plugs: [
          StaffNotesApi.TokenAuthentication,
          StaffNotesWeb.SlidingSessionTimeout
        ],
        Sockets: [
          ~r{^StaffNotesWeb.*Socket$}
        ],
        Test: [
          ~r{^StaffNotes.*(Channel|Conn|Data)Case$},
          ~r{^StaffNotes.Support}
        ],
        Views: [
          ~r{^StaffNotesWeb.*View$}
        ]
      ],
      extras: [
        "CONTRIBUTING.md",
        "CODE_OF_CONDUCT.md": [
          filename: "code_of_conduct",
          title: "Code of Conduct"
        ],
        "README.md": [
          filename: "readme",
          title: "README"
        ],
        "LICENSE.md": [
          filename: "license",
          title: "License"
        ]
      ]
    ]
  end

  # When generating test documentation, make the default page land in the test docs
  defp docs_main(:test), do: "StaffNotes.Support.Helpers"
  defp docs_main(_), do: "readme"

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
