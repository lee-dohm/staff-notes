defmodule StaffNotesWeb.PageController do
  @moduledoc """
  Handles requests for pages at the root.
  """
  use StaffNotesWeb, :controller

  import Ecto.Query

  alias StaffNotes.Notes.Note
  alias StaffNotes.Repo

  @doc """
  Displays the home page.
  """
  def index(conn, _params) do
    user = conn.assigns[:current_user]

    render_index(conn, user)
  end

  defp render_index(conn, nil), do: render(conn, "index_logged_out.html")

  defp render_index(conn, user) do
    notes =
      Repo.all(
        from(
          n in Note,
          join: ou in "organizations_users",
          on: n.organization_id == ou.organization_id,
          where: ou.user_id == ^user.id,
          order_by: [desc: n.inserted_at],
          preload: [:member, :organization]
        )
      )

    render(conn, "index_logged_in.html", notes: notes, user: user)
  end

  @doc """
  Displays the about page.
  """
  def about(conn, _params) do
    render(conn, "about.html")
  end
end
