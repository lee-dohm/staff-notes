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
  def create(conn, %{"organization" => org}) do
    case Accounts.create_org(org, conn.assigns.current_user) do
      {:ok, results} ->
        redirect(conn, to: organization_path(conn, :show, results.org))
      {:error, :org, changeset, %{}} ->
        render(conn, "new.html", changeset: changeset)
    end
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
  def edit(conn, %{"name" => name}) do
    org =
      name
      |> Accounts.get_org!()
      |> Repo.preload([:teams, :users])

    changeset = Organization.changeset(org, %{})

    render(conn, "edit.html", changeset: changeset, name: name, org: org)
  end

  @doc """
  Renders a form for creating a new organization.
  """
  def new(conn, _params) do
    changeset = Organization.changeset(%Organization{}, %{})

    render(conn, "new.html", changeset: changeset)
  end

  @doc """
  Renders an organization by name.
  """
  @spec show(Plug.Conn.t, StaffNotesWeb.params) :: Plug.Conn.t
  def show(conn, params)
  def show(conn, %{"name" => name}) do
    org =
      name
      |> Accounts.get_org!()
      |> Repo.preload([:teams, :users])

    render(conn, "show.html", org: org)
  end

  @doc """
  Receives parameters for updating an organization and saves it to the database.
  """
  def update(conn, %{"name" => name, "organization" => attrs}) do
    org =
      name
      |> Accounts.get_org!()
      |> Repo.preload([:teams, :users])

    case Accounts.update_org(org, attrs) do
      {:ok, updated} -> redirect(conn, to: organization_path(conn, :show, updated))
      {:error, changeset} -> render(conn, "edit.html", changeset: changeset, name: name, org: org)
    end
  end
end