defmodule StaffNotesWeb.OrganizationController do
  @moduledoc """
  Handles requests for `StaffNotes.Accounts.Organization` records.
  """
  use StaffNotesWeb, :controller

  alias StaffNotes.Accounts
  alias StaffNotes.Repo

  @doc """
  Display the profile page for the organization.
  """
  @spec show(Plug.Conn.t, StaffNotesWeb.params) :: Plug.Conn.t
  def show(conn, params)
  def show(conn, %{"id" => id}) do
    org =
      id
      |> Accounts.get_org!()
      |> Repo.preload([:teams, :users])

    conn
    |> assign(:org, org)
    |> render("show.html")
  end
end
