defmodule StaffNotesWeb.UserController do
  @moduledoc """
  Handles requests under the `/user` path.
  """
  use StaffNotesWeb, :controller

  alias StaffNotes.Accounts

  @doc """
  Displays the profile page for a user.
  """
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    conn
    |> assign(:user, user)
    |> render("show.html")
  end
end
