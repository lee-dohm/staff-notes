defmodule StaffNotesWeb.StaffController do
  @moduledoc """
  Handles requests for `StaffNotes.Accounts.User` records as staff of an organizaton.
  """
  use StaffNotesWeb, :controller

  alias StaffNotes.Accounts

  def index(conn, %{"organization_name" => name}) do
    org = Accounts.get_org!(name, with: [:users])

    render(conn, "index.html", org: org)
  end
end
