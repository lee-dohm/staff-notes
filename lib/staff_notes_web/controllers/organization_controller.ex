defmodule StaffNotesWeb.OrganizationController do
  @moduledoc """
  Handles requests for `StaffNotes.Accounts.Organization` records.
  """
  use StaffNotesWeb, :controller

  alias StaffNotes.Accounts
  alias StaffNotes.Repo

  @doc """
  Receives parameters for creating a new organization and saves it in the database.
  """
  def create(conn, _params) do
    conn
  end

  @doc """
  Receives an organization to be deleted by id and deletes it from the database.
  """
  def delete(conn, _params) do
    conn
  end

  @doc """
  Receives an organization by id and renders a form for editing it.
  """
  def edit(conn, _params) do
    conn
  end

  @doc """
  Renders a form for creating a new organization.
  """
  def new(conn, _params) do
    conn
  end

  @doc """
  Renders an organization by id.
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

  @doc """
  Receives paramets for updating an organization and saves it to the database.
  """
  def update(conn, _params) do
    conn
  end
end
