defmodule StaffNotesWeb.OrganizationView do
  @moduledoc """
  View functions for `StaffNotes.Accounts.Organization` templates.
  """
  use StaffNotesWeb, :view

  alias StaffNotes.Notes

  def create_note_button(conn, org, options \\ []) do
    link_options = Keyword.merge(options, to: organization_note_path(conn, :new, org), type: "button")

    link(gettext("Create staff note"), link_options)
  end

  def render_note_list(conn, org) do
    notes = Notes.list_notes(org)

    do_render_note_list(conn, org, notes)
  end

  defp do_render_note_list(conn, org, notes) when length(notes) == 0 do
    render(__MODULE__, "note_list_blankslate.html", conn: conn, org: org)
  end

  defp do_render_note_list(conn, org, notes) do
    render(__MODULE__, "note_list.html", conn: conn, org: org, notes: notes)
  end
end
