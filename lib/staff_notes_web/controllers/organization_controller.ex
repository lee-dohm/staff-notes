defmodule StaffNotesWeb.OrganizationController do
  @moduledoc """
  Handles requests for `StaffNotes.Accounts.Organization` records.
  """
  use StaffNotesWeb, :controller

  alias StaffNotes.Accounts
  alias StaffNotes.Accounts.Organization
  alias StaffNotes.Repo
  alias StaffNotesWeb.ErrorView

  @doc """
  Receives parameters for creating a new organization and saves it in the database.
  """
  def create(conn, _params) do
    conn
  end

  @doc """
  Receives an organization to be deleted by name and deletes it from the database.
  """
  def delete(conn, _params) do
    conn
  end

  @doc """
  Receives an organization by name and renders a form for editing it.
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
  Renders an organization by name.
  """
  @spec show(Plug.Conn.t, StaffNotesWeb.params) :: Plug.Conn.t
  def show(conn, params)
  def show(conn, %{"name" => name}), do: do_show(conn, Accounts.get_org(name))

  defp do_show(conn, nil) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render("404.html")
  end

  defp do_show(conn, %Organization{} = org) do
    org = Repo.preload(org, [:teams, :users])

    conn
    |> assign(:org, org)
    |> render("show.html")
  end

  @doc """
  Receives parameters for updating an organization and saves it to the database.
  """
  def update(conn, _params) do
    conn
  end
end
