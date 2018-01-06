defmodule StaffNotes.Support.Helpers do
  @moduledoc """
  Function helpers for tests.

  There are two types of helper functions:

  * `fixture` functions that create records in the database and return the data object
  * `setup` functions that are intended to be called from `ExUnit.Callbacks.setup/1` to add items
  to the test context

  ## Examples

  ```
  setup [:setup_regular_user]

  test "a test that needs a regular user", context do
    user = context.regular_user

    assert user.name == "user name"
  end
  ```
  """
  alias StaffNotes.Accounts

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
  Creates a standard user and adds it to the test context as `:regular_user`.
  """
  def setup_regular_user(_context) do
    {:ok, regular_user: user_fixture()}
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

  defp org_attrs, do: %{name: "org name"}
  defp team_attrs, do: %{name: "team name", permission: :write, original: false}
  defp user_attrs, do: %{avatar_url: "some avatar_url", id: 42, name: "user name", site_admin: false}
end
