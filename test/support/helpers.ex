defmodule StaffNotes.Support.Helpers do
  @moduledoc """
  Function helpers for tests.

  There are three types of helper functions:

  * Functions that end in `?` are tests intended to be used in assertions
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
  alias Plug.Conn.Status
  alias StaffNotes.Accounts
  alias StaffNotesWeb.ErrorView

  import Phoenix.Controller, only: [view_module: 1, view_template: 1]

  @doc """
  Determines whether the appropriate module and template was rendered for the given error.
  """
  @spec error_rendered?(Plug.Conn.t, atom | integer) :: boolean
  def error_rendered?(conn, error)
  def error_rendered?(conn, atom) when is_atom(atom), do: error_rendered?(conn, Status.code(atom))
  def error_rendered?(conn, integer) when is_integer(integer) do
    rendered?(conn, ErrorView, "#{integer}.html")
  end

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
  Determines whether the given view module and template were rendered.
  """
  @spec rendered?(Plug.Conn.t, module | nil, String.t) :: boolean
  def rendered?(conn, module \\ nil, template)
  def rendered?(conn, nil, template), do: view_template(conn) == template
  def rendered?(conn, module, template) do
    view_module(conn) == module && rendered?(conn, template)
  end

  @doc """
  Creates a standard organization and adds it to the test context as `:regular_org`
  """
  def setup_regular_org(_context) do
    {:ok, regular_org: org_fixture()}
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

  defp org_attrs, do: %{name: "org-name"}
  defp team_attrs, do: %{name: "team-name", permission: :write, original: false}
  defp user_attrs, do: %{avatar_url: "some avatar_url", id: 42, name: "user-name", site_admin: false}
end
