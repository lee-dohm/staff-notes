defmodule StaffNotes.Support.Helpers do
  @moduledoc """
  Helpers for tests.
  """
  alias StaffNotes.Accounts

  def org_attrs, do: %{name: "org name"}
  def team_attrs, do: %{name: "team name", permission: :write, original: false}
  def user_attrs, do: %{avatar_url: "some avatar_url", id: 42, name: "user name", site_admin: false}

  @doc """
  Inserts a new organization into the database and returns it.
  """
  def org_fixture(attrs \\ %{}) do
    {:ok, org} =
      attrs
      |> Enum.into(org_attrs())
      |> Accounts.create_org()

    org
  end

  @doc """
  Inserts a new team belonging to the given org into the database and returns it.
  """
  def team_fixture(attrs \\ %{}, org) do
    {:ok, team} =
      attrs
      |> Enum.into(team_attrs())
      |> Accounts.create_team(org)

    team
  end

  @doc """
  Inserts a new user into the database and returns it.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(user_attrs())
      |> Accounts.create_user()

    user
  end
end
