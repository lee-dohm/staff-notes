defmodule StaffNotesWeb.MemberController do
  @moduledoc """
  Handles requests for `StaffNotes.Notes.Member` records.
  """
  use StaffNotesWeb, :controller

  alias StaffNotes.Accounts
  alias StaffNotes.Notes
  alias StaffNotes.Repo

  def index(conn, %{"organization_name" => name}) do
    org = Accounts.get_org!(name, with: [members: [:organization]])

    render(conn, "index.html", org: org)
  end

  def show(conn, %{"id" => id}) do
    member =
      id
      |> Notes.get_member!()
      |> Repo.preload([:organization])

    render(conn, "show.html", member: member)
  end
end
