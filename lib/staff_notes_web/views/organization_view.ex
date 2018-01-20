defmodule StaffNotesWeb.OrganizationView do
  @moduledoc """
  View functions for `StaffNotes.Accounts.Organization` templates.
  """
  use StaffNotesWeb, :view

  def create_note_button(conn, org, options \\ []) do
    link_options =
      Keyword.merge(options, to: organization_note_path(conn, :new, org), type: "button")

    link(gettext("Create staff note"), link_options)
  end
end
