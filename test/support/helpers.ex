defmodule StaffNotes.Support.Helpers do
  @moduledoc """
  Function helpers for tests.

  There are a few common types of helper functions:

  * Functions that are intended to be used in assertions end in `?`
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
  alias StaffNotes.Accounts.User
  alias StaffNotes.Accounts.Organization
  alias StaffNotes.Markdown
  alias StaffNotes.Notes
  alias StaffNotes.Notes.Note
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
  Replaces characters in the string with their HTML-escaped versions.
  """
  def escape(text), do: String.replace(text, "'", "&#39;", global: true)

  @doc """
  Creates `StaffNotes.Markdown` struct from a string.
  """
  def markdown(text, options \\ [])

  def markdown(text, []) do
    %Markdown{text: text, html: Markdown.to_html(text)}
  end

  def markdown(text, rendered: false) do
    %Markdown{text: text, html: nil}
  end

  @doc """
  Inserts a new note into the database and returns it.
  """
  def note_fixture(attrs \\ %{}, %User{} = author, %Organization{} = org) do
    {:ok, note} =
      attrs
      |> Enum.into(note_attrs())
      |> Notes.create_note(author, org)

    %Note{note | text: %Markdown{text: note.text.text, html: Markdown.to_html(note.text.text)}}
  end

  @doc """
  Inserts a new organization into the database and returns it.
  """
  def org_fixture(attrs \\ %{}, %User{} = user) do
    {:ok, %{org: org}} =
      attrs
      |> Enum.into(org_attrs())
      |> Accounts.create_org(user)

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
  Creates a standard note, all of its prerequisites, and adds it to the context as `:regular_note`.
  """
  def setup_regular_note(_context) do
    author = user_fixture()
    org = org_fixture(author)

    {
      :ok,
      author: author,
      regular_note: note_fixture(author, org),
      regular_org: org,
      regular_user: author
    }
  end

  @doc """
  Creates a standard organization and adds it to the test context as `:regular_org`
  """
  def setup_regular_org(%{regular_user: user}) do
    {:ok, regular_org: org_fixture(user)}
  end

  def setup_regular_org(_context) do
    user = user_fixture()

    {:ok, regular_org: org_fixture(user), regular_user: user}
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

  defp note_attrs, do: %{text: "some text"}
  defp org_attrs, do: %{name: "org-name"}
  defp team_attrs, do: %{name: "team-name", permission: :write, original: false}
  defp user_attrs, do: %{avatar_url: "some avatar_url", id: 42, name: "user-name", site_admin: false}
end
