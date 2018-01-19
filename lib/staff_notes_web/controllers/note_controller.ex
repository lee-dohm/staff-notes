defmodule StaffNotesWeb.NoteController do
  @moduledoc """
  Handles requests for `StaffNotes.Notes.Note` records.
  """
  use StaffNotesWeb, :controller

  alias StaffNotes.Accounts
  alias StaffNotes.Notes
  alias StaffNotes.Notes.Note
  alias StaffNotes.Repo
  alias StaffNotesWeb.NoteController

  @doc """
  Receives parameters for creating a new note for an organization and stores it in the database.
  """
  def create(conn, %{"organization_name" => org_name, "note" => note}) do
    author = conn.assigns.current_user
    org = Accounts.get_org!(org_name)

    case Notes.create_note(note, author, org) do
      {:ok, note} -> redirect(conn, to: organization_note_path(conn, :show, org, note))
      {:error, changeset} -> render(conn, "new.html", changeset: changeset, org: org)
    end
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
  def edit(conn, %{"organization_name" => org_name, "id" => id}) do
    org = Accounts.get_org!(org_name)

    changeset =
      id
      |> Notes.get_note!()
      |> Notes.change_note()

    render(conn, "edit.html", changeset: changeset, id: id, org: org)
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
  def show(conn, %{"id" => id}) do
    note =
      id
      |> Notes.get_note!()
      |> Repo.preload([:author, :organization])

    render(conn, "show.html", note: note)
  end

  @doc """
  Receives parameters for updating a note and saves it to the database.
  """
  def update(conn, %{"organization_name" => org_name, "id" => id, "note" => attrs}) do
    org = Accounts.get_org!(org_name)
    note = Notes.get_note!(id)

    case Notes.update_note(note, attrs) do
      {:ok, updated} -> redirect(conn, to: organization_note_path(conn, :show, org, updated))
      {:error, changeset} -> render(conn, "edit.html", changeset: changeset, id: id, org: org)
    end
  end
end