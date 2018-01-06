defmodule StaffNotesWeb.UserController do
  @moduledoc """
  Handles requests under the `/user` path.
  """
  use StaffNotesWeb, :controller

  alias StaffNotes.Accounts
  alias StaffNotesWeb.ErrorView

  @doc """
  Displays the profile page for a user.

  Returns 404 if the user is not found.
  """
  def show(conn, %{"name" => name}), do: do_show(conn, Accounts.get_user(name))

  defp do_show(conn, nil) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render("404.html")
  end

  defp do_show(conn, user) do
    conn
    |> assign(:user, user)
    |> render("show.html")
  end
end
