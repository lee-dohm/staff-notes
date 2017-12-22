defmodule StaffNotes.Mixfile do
  use Mix.Project

  def project do
    [
      app: :staff_notes,
      version: "0.0.1",

      name: "Staff Notes",
      homepage_url: "https://www.staffnotes.io",
      source_url: "https://github.com/lee-dohm/staff-notes",

      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(),
      docs: docs(),
      preferred_cli_env: [espec: :test]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {StaffNotes.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:cmark, "~> 0.7"},
      {:cowboy, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix, "~> 1.3.0"},
      {:phoenix_octicons, "~> 0.2.0"},
      {:phoenix_slime, "~> 0.9"},
      {:postgrex, ">= 0.0.0"},
      {:ex_doc, "~> 0.18", only: :dev, runtime: false},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:espec_phoenix, "~> 0.6", only: :test}
    ]
  end

  defp docs do
    [
      main: "readme",
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

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]
end
