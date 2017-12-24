defmodule IExHelpers do
  @moduledoc """
  Helper functions for use in `IEx`.
  """

  alias StaffNotes.Accounts
  alias StaffNotes.Accounts.User

  @doc """
  Cleanly shuts down the local node and exits the shell.
  """
  def exit, do: System.stop()

  @doc """
  Demotes the named user to a normal non-admin account.
  """
  def demote_user(name) when is_binary(name), do: name |> Accounts.get_user! |> demote_user
  def demote_user(%User{} = user), do: Accounts.update_user(user, %{site_admin: false})

  @doc """
  Promotes the named user to a site admin.
  """
  def promote_user(name) when is_binary(name), do: name |> Accounts.get_user! |> promote_user
  def promote_user(%User{} = user), do: Accounts.update_user(user, %{site_admin: true})
end
