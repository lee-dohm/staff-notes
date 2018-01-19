defmodule StaffNotes.IEx.Helpers do
  @moduledoc """
  Helper functions for use in the `IEx` console.

  All of these functions are available directly at the interactive prompt with no namespace
  necessary.
  """
  alias Ecto.Query
  alias StaffNotes.Accounts
  alias StaffNotes.Accounts.User
  alias StaffNotes.Repo

  @doc """
  Cleanly shuts down the local node and exits the shell.
  """
  def exit, do: System.stop()

  @doc """
  Demotes the named user to a normal non-admin account.

  Raises an `Ecto.NoResultsError` if the named user cannot be found.
  """
  @spec demote_user!(String.t()) :: User.t() | no_return
  def demote_user!(name) when is_binary(name), do: name |> Accounts.get_user!() |> demote_user

  @doc """
  Demotes the given user to a normal non-admin account.
  """
  @spec demote_user(User.t()) :: User.t()
  def demote_user(%User{} = user), do: Accounts.update_user(user, %{site_admin: false})

  @doc """
  Gets the first record that matches the given query.

  ## Examples

  ```
  dat Organization
  ```
  """
  def dat(queryable) do
    queryable
    |> Query.first()
    |> Repo.one()
  end

  @doc """
  Promotes the named user to a site admin.

  Raises an `Ecto.NoResultsError` if the named user cannot be found.
  """
  @spec promote_user!(String.t() | User.t()) :: User.t() | no_return
  def promote_user!(name) when is_binary(name), do: name |> Accounts.get_user!() |> promote_user

  @doc """
  Promotes the given user to a site admin.
  """
  @spec promote_user(User.t()) :: User.t()
  def promote_user(%User{} = user), do: Accounts.update_user(user, %{site_admin: true})
end
