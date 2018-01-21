defmodule StaffNotesWeb.MemberController do
  @moduledoc """
  Handles requests for `StaffNotes.Notes.Member` records.
  """
  use StaffNotesWeb, :controller

  alias StaffNotes.Accounts

  def index(conn, %{"organization_name" => name}) do
    org = Accounts.get_org!(name, with: [members: [:organization]])

    render(conn, "index.html", org: org)
  end
end
