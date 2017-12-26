defmodule StaffNotesWeb.UserController do
  @moduledoc """
  Handles requests under the `/user` path.
  """
  use StaffNotesWeb, :controller

  alias StaffNotes.Accounts

  @doc """
  Displays the profile page for a user.
  """
  def show(conn, %{"name" => name}) do
    user = Accounts.get_user!(name)

    conn
    |> assign(:user, user)
    |> render("show.html")
  end
end
