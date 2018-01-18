defmodule StaffNotesWeb.NoteController do
  @moduledoc """
  Handles requests for `StaffNotes.Notes.Note` records.
  """
  use StaffNotesWeb, :controller

  alias StaffNotes.Accounts
  alias StaffNotes.Notes
  alias StaffNotes.Notes.Note

  @doc """
  Receives parameters for creating a new note for an organization and stores it in the database.
  """
  def create(conn, _params) do
    conn
  end

  @doc """
  Receives a note to be deleted and deletes it from the database.
  """
  def delete(conn, _params) do
    conn
  end

  @doc """
  Receives a note and renders a form for editing it.
  """
  def edit(conn, _params) do
    conn
  end

  @doc """
  Displays the list of notes for an organization.
  """
  def index(conn, %{"organization_name" => _name}) do
    conn
  end

  @doc """
  Renders a form for creating a new note for an organization.
  """
  def new(conn, %{"organization_name" => name}) do
    org = Accounts.get_org!(name)
    changeset = Notes.change_note(%Note{})

    render(conn, "new.html", changeset: changeset, org: org)
  end

  @doc """
  Displays a note.
  """
  def show(conn, %{"id" => _id}) do
    conn
  end

  @doc """
  Receives parameters for updating a note and saves it to the database.
  """
  def update(conn, _params) do
    conn
  end
end
