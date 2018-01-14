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
    changeset =
      name
      |> Accounts.get_org!()
      |> Organization.changeset(%{})

    render(conn, "edit.html", changeset: changeset, name: name)
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
  def update(conn, %{"name" => name, "organization" => attrs}) do
    org = Accounts.get_org(name)

    case Accounts.update_org(org, attrs) do
      {:ok, updated} -> redirect(conn, to: organization_path(conn, :show, updated))
      {:error, changeset} -> render(conn, "edit.html", changeset: changeset, name: name)
    end
  end
end
