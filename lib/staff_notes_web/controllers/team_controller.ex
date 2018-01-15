defmodule StaffNotesWeb.TeamController do
  @moduledoc """
  Handles requests for `StaffNotes.Accounts.Team` records.

  All actions are for teams within an organization. The organization is identified by the
  `organization_name` parameter.
  """
  use StaffNotesWeb, :controller

  alias StaffNotes.Accounts
  alias StaffNotes.Repo

  @doc """
  Receives parameters for creating a new team for an organization and stores it in the database.
  """
  def create(conn, _params) do
    conn
  end

  @doc """
  Receives a team to be deleted from an organization by name and deletes it from the database.
  """
  def delete(conn, _params) do
    conn
  end

  @doc """
  Receives a team within an organization by name and renders a form for editing it.
  """
  def edit(conn, _params) do
    conn
  end

  @doc """
  Displays the list of teams for an organization.
  """
  def index(conn, %{"organization_name" => name}) do
    org = Accounts.get_org!(name, with: [teams: [:organization]])

    render(conn, "index.html", org: org)
  end

  @doc """
  Renders a form for creating a new team for an organization.
  """
  def new(conn, _params) do
    conn
  end

  @doc """
  Displays a team for an organization.
  """
  def show(conn, %{"organization_name" => org_name, "name" => team_name}) do
    team =
      org_name
      |> Accounts.get_team!(team_name)
      |> Repo.preload([:organization])

    render(conn, "show.html", team: team)
  end

  @doc """
  Receives parameters for updating a team within an organization and saves it to the database.
  """
  def update(conn, _params) do
    conn
  end
end
