defmodule StaffNotesWeb.UserController do
  @moduledoc """
  Handles requests for `StaffNotes.Accounts.User` records.
  """
  use StaffNotesWeb, :controller

  alias StaffNotes.Accounts

  @doc """
  Displays the profile page for a user.

  Raises `Ecto.NoResultsError` if the user is not found.
  """
  @spec show(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def show(conn, params)
  def show(conn, %{"name" => name}) do
    user = Accounts.get_user!(name)

    conn
    |> assign(:user, user)
    |> render("show.html")
  end
end
